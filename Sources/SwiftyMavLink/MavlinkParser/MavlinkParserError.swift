//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

public enum MavlinkParserError: ErrorProtocol {
    
    /**
     Size of expected number is larger than received data size
     - offset: Expected number offset in received data
     - size: Expected number size in bytes
     */
    case NumberSizeOutOfBounds(offset: Int, size: Int)
    
    /**
     Length check of payload for known `messageId` failed
     - messageId: Message id of expected Message
     - receivedLength: Received payload length
     - properLength: Expected payload length for `messageId`
     */
    case InvalidPayloadLength(messageId: UInt8, receivedLength: UInt8, properLength: UInt8)
    
    /**
     Received `messageId` was not recognized so we can't create appropirate Message
     - messageId: Id of message that was not found in known message list (`messageIdToClass` array)
     */
    case UnknownMessageId(messageId: UInt8)
    
    /// Checksum check failed. Message id is known but calculated CRC bytes does not match received CRC value
    case BadCRC
}
