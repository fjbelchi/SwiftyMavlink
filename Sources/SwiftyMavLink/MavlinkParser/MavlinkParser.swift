//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

public typealias Channel = UInt8

/// Alternative way to receive parsed Messages and all errors is to implement this protocol and set Parsers delegate
public protocol MavlinkParserDelegate: class {
    
    /**
     Called when MAVLink Packet is successfully received, payload length and CRC checks are passed
     
     - Parameter parser: `Parser` object that handled `packet`
     - Parameter packet: Completely received `Packet`
     - Parameter channel: Channel on which `packet` was received
     
     - Returns: `Void`
     */
    func parser(parser: MavlinkParser, didReceivePacket packet: Packet, channel: Channel)
    
    /**
     Packet receiving failed because `InvalidPayloadLength` or `BadCRC` error
     
     - Parameter parser: `Parser` object that received `data`
     - Parameter error: Error that  occurred while receiving `data` (`InvalidPayloadLength` or `BadCRC` error)
     - Parameter data: Partially received `Packet`
     - Parameter channel: Channel on which `data` was received
     
     - Returns: `Void`
     */
    func parser(parser: MavlinkParser, didFailToReceivePacketWithError error: ErrorProtocol, data: Packet?, channel: Channel)
    
    /**
     Called when received data was successfully parsed into appropriate `message` structure
     
     - Parameter parser: `Parser` object that handled `packet`
     - Parameter message: Successfully parsed `Message`
     - Parameter packet: Completely received `Packet`
     - Parameter channel: Channel on which `message` was received
     
     - Returns: `Void`
     */
    func parser(parser: MavlinkParser, didParseMessage message: Message, fromPacket packet: Packet, channel: Channel)
    
    /**
     Called when `packet` completely received but `Parser` was not able to finish `Message` processing due unknown `messageId` or type validation errors
     
     - Parameter parser: `Parser` object that handled `packet`
     - Parameter packet: Completely received `Packet`
     - Parameter error: Error that  occurred while parsing `packet`s payload into `Message`
     - Parameter channel: Channel on which `message` was received
     
     - Returns: `Void`
     */
    func parser(parser: MavlinkParser, didFailToParseMessageFromPacket packet: Packet, withError error: ErrorProtocol, channel: Channel)
}

/**
 Main parser class, performs `Packet` receiving, recognition, validation and `Message` structure creation. Also returns errors through delegation if any errors occurred.
 */
public class MavlinkParser {
    
    /// MAVlink constants used for packet parsing
    struct Constants {
        
        /// Packet start sign. Indicates the start of a new packet. v1.0
        static let PacketStx: UInt8 = 0xFE
    }
    
    /// States for the parsing state machine
    enum ParseState {
        case Uninit
        case Idle
        case GotStx
        case GotSequence
        case GotLength
        case GotSystemId
        case GotComponentId
        case GotMessageId
        case GotPayload
        case GotCRC1
        case GotBadCRC1
    }
    
    enum Framing: UInt8 {
        case Incomplete = 0
        case Ok = 1
        case BadCRC = 2
    }
    
    /// Storage for MAVLink parsed packets, states and errors statistics
    class Status {
        
        /// Number of received packets
        var packetReceived: Framing = .Incomplete
        
        /// Number of parse errors
        var parseError: UInt8 = 0
        
        /// Parsing state machine
        var parseState: ParseState = .Uninit
        
        /// Sequence number of last packet received
        var currentRxSeq: UInt8 = 0
        
        /// Sequence number of last packet sent
        var currentTxSeq: UInt8 = 0
        
        /// Received packets
        var packetRxSuccessCount: UInt16 = 0
        
        /// Number of packet drops
        var packetRxDropCount: UInt16 = 0
    }
    
    /// Parser Packets and States buffers
    let channelBuffers = [Packet](repeating: Packet(), count: Int(Channel.max))
    let channelStatuses = [Status](repeating: Status(), count: Int(Channel.max))
    
    /// Object to pass received packets, messages, errors to
    public var delegate: MavlinkParserDelegate?
    
    /// Enable this option to check the length of each message. This allows invalid messages to be caught much sooner. Use if the transmission medium is prone to missing (or extra) characters (e.g. a radio that fades in and out). Only use if the channel will only contain messages types listed in the headers.
    public var checkMessageLength = true
    
    /// Use one extra CRC that is added to the message CRC to detect mismatches in message specifications. This is to prevent that two devices using different message versions incorrectly decode a message with the same length.
    public var crcExtra = true
    
    /**
     This is a convenience function which handles the complete MAVLink parsing. The function will parse one byte at a time and return the complete packet once it could be successfully decoded. Checksum and other failures will be delegated to `delegate`.
     
     - Parameter char: The char to barse
     - Parameter chan: ID of the current channel. This allows to parse different channels with this function. A channel is not a physical message channel like a serial port, but a logic partition of the communication streams in this case.
     
     - Returns: `nil` if no packet could be decoded, the `Packet` structure else
     */
    public func parseChar(char: UInt8, channel: Channel) -> Packet? {
        
        /// Function to check if current char is Stx byte. If current char is STX, modifies current rxpack and status.
        func handleStxChar(char: UInt8, rxpack: Packet, status: Status) {
            if char == Constants.PacketStx {
                rxpack.length = 0
                rxpack.channel = channel
                rxpack.magic = char
                rxpack.checksum.start()
                status.parseState = .GotStx
            }
        }
        
        let rxpack = channelBuffers[Int(channel)]
        let status = channelStatuses[Int(channel)]
        
        status.packetReceived = .Incomplete
        
        switch status.parseState {
        case .Uninit, .Idle:
            handleStxChar(char: char, rxpack: rxpack, status: status)
            
        case .GotStx:
            rxpack.length = char
            rxpack.payload.length = 0
            rxpack.checksum.accumulateChar(char: char)
            status.parseState = .GotLength
            
        case .GotLength:
            rxpack.sequence = char
            rxpack.checksum.accumulateChar(char: char)
            status.parseState = .GotSequence
            
        case .GotSequence:
            rxpack.systemId = char
            rxpack.checksum.accumulateChar(char: char)
            status.parseState = .GotSystemId
            
        case .GotSystemId:
            rxpack.componentId = char
            rxpack.checksum.accumulateChar(char: char)
            status.parseState = .GotComponentId
            
        case .GotComponentId:
            // Check Message length is `checkMessageLength` enabled and `messageLengths` contains proper id.
            // If `messageLengths` does not contain info for current messageId, parsing will fail later on CRC check.
            if checkMessageLength && (Mavlink.messages[char] != nil) {
                if let messageLength = Mavlink.messages[char]?.length() where rxpack.length != messageLength {
                    status.parseError += 1
                    status.parseState = .Idle
                    let error = MavlinkParserError.InvalidPayloadLength(messageId: char, receivedLength: rxpack.length, properLength: messageLength)
                    delegate?.parser(parser:self, didFailToReceivePacketWithError: error, data: nil, channel: channel)
                    break
                }
            }
            rxpack.messageId = char
            rxpack.checksum.accumulateChar(char: char)
            if rxpack.length == 0 {
                status.parseState = .GotPayload
            } else {
                status.parseState = .GotMessageId
            }
            
        case .GotMessageId:
            var char = char
            rxpack.payload.append(&char, length: strideofValue(char))
            rxpack.checksum.accumulateChar(char: char)
            if rxpack.payload.length == Int(rxpack.length) {
                status.parseState = .GotPayload
            }
            
        case .GotPayload:
            if crcExtra && (Mavlink.messages[rxpack.messageId] != nil) { // `if let where` usage will force array lookup even if `crcExtra` is false
                if let extra = Mavlink.messages[rxpack.messageId]?.CRSsExtra() {
                    rxpack.checksum.accumulateChar(char: extra)
                }
            }
            if char != rxpack.checksum.lowByte {
                status.parseState = .GotBadCRC1
            } else {
                status.parseState = .GotCRC1
            }
            var char = char
            rxpack.payload.append(&char, length: strideofValue(char))
            
        case .GotCRC1, .GotBadCRC1:
            if (status.parseState == .GotBadCRC1) || (char != rxpack.checksum.highByte) {
                status.parseError += 1
                status.packetReceived = .BadCRC
                let error = Mavlink.messages[rxpack.messageId] == nil ? MavlinkParserError.UnknownMessageId(messageId: rxpack.messageId) : MavlinkParserError.BadCRC
                delegate?.parser(parser: self, didFailToReceivePacketWithError: error, data: Packet(packet: rxpack), channel: channel)
            } else {
                // Successfully got message
                var char = char
                rxpack.payload.append(&char, length: strideofValue(char))
                status.packetReceived = .Ok
            }
            status.parseState = .Idle
        }
        
        defer {
            // Сollect stat here
            
            status.parseError = 0
        }
        
        // If a packet has been sucessfully received
        guard status.packetReceived == .Ok else {
            return nil
        }
        
        // Copy and delegate received packet
        let packet = Packet(packet: rxpack)
        delegate?.parser(parser: self, didReceivePacket: packet, channel: channel)
        
        status.currentRxSeq = rxpack.sequence
        // Initial condition: If no packet has been received so far, drop count is undefined
        if status.packetRxSuccessCount == 0 {
            status.packetRxDropCount = 0;
        }
        // Count this packet as received
        status.packetRxSuccessCount = status.packetRxSuccessCount &+ 1
        
        // Try to create appropriate Message structure, delegate results
        guard let messageClass = Mavlink.messages[packet.messageId] else {
            let error = MavlinkParserError.UnknownMessageId(messageId: rxpack.messageId)
            delegate?.parser(parser: self, didFailToParseMessageFromPacket: packet, withError: error, channel: channel)
            return packet
        }
        
        do {
            packet.message = try messageClass.init(data: rxpack.payload as Data)
            delegate?.parser(parser: self, didParseMessage: packet.message!, fromPacket: packet, channel: channel)
        } catch {
            delegate?.parser(parser: self, didFailToParseMessageFromPacket: packet, withError: error, channel: channel)
            return packet
        }
        
        return packet
    }
    
    /**
     Append new portion of data to existing buffer, then call `messageHandler` if new message is available.
     
     - Parameter data: The data to be parsed.
     - Parameter channel: ID of the current channel. This allows to parse different channels with this function. A channel is not a physical message channel like a serial port, but a logic partition of the communication streams in this case.
     - Parameter messageHandler: The message handler to call when the provided data is enought to complete message parsing. Unless you have provided a custom delegate, this parameter must not be `nil`, because there is no other way to retrieve the parsed message and packet.
     
     - Returns: `Void`
     */
    public func appendData(data: Data, channel: Channel, messageHandler:((message: Message, packet: Packet) -> Void)? = nil) {
        let stream = InputStream(data: data)
        var totalBytesRead: Int = 0
        
        stream.open()
        
        while (totalBytesRead < data.count) {
            var char: UInt8 = 0
            let numberOfBytesRead = stream.read(&char, maxLength: strideofValue(char))
            if let packet = parseChar(char: char, channel: channel), message = packet.message, messageHandler = messageHandler {
                messageHandler(message: message, packet: packet)
            }
            totalBytesRead += numberOfBytesRead
        }
    }
}

