//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

/**
 MAVLink Packet structure to store received data that is not full message yet. Contains additional to Message info as channel, system id, component id and raw payload data, etc. Also used to store and transfer received data of unknown or corrupted Messages. [More details](http://qgroundcontrol.org/mavlink/start)
 */
public class Packet {
    
    /// MAVlink Packet constants
    struct Constants {
        
        /// Maximum packets payload length
        static let MaxPayloadLength = 255
        static let NumberOfChecksumBytes = 2
    }
    
    /// Channel on which packet was received
    public internal(set) var channel: UInt8 = 0
    
    /// Sent at end of packet
    public internal(set) var checksum: Checksum = Checksum()
    
    /// Protocol magic marker (PacketStx value)
    public internal(set) var magic: UInt8 = 0
    
    /// Length of payload
    public internal(set) var length: UInt8 = 0
    
    /// Sequence of packet
    public internal(set) var sequence: UInt8 = 0
    
    /// ID of message sender system/aircraft
    public internal(set) var systemId: UInt8 = 0
    
    /// ID of the message sender component
    public internal(set) var componentId: UInt8 = 0
    
    /// ID of message in payload
    public internal(set) var messageId: UInt8 = 0
    
    /// Message bytes
    public internal(set) var payload: NSMutableData = NSMutableData(capacity: Constants.MaxPayloadLength + Constants.NumberOfChecksumBytes)!
    
    /// Received Message structure if available
    public internal(set) var message: Message?
    
    /**
     Initialize copy of provided Packet
     
     - Parameter packet: Packet to copy
     */
    init(packet: Packet) {
        channel = packet.channel
        checksum = packet.checksum
        magic = packet.magic
        length = packet.length
        sequence = packet.sequence
        systemId = packet.systemId
        componentId = packet.componentId
        messageId = packet.messageId
        payload = NSMutableData(data: packet.payload as Data)
        message = packet.message
    }
    
    init() { }
}
