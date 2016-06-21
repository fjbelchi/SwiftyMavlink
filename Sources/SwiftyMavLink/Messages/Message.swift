//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

public protocol MavlinkEncodeMessage {
    func encode() -> [UInt8]
}

public protocol Message: MavlinkEncodeMessage {
    static func messageId() -> UInt8
    static func systemId() -> UInt8
    static func componentId() -> UInt8
    static func messageLength() -> UInt8
    static func CRSsExtra() -> UInt8
    
    init(data: Data) throws
}

public extension Message {
    
    static func length() -> Int {
        return Int(messageLength()) + 6 + 2 // 6 bytes = header, 2 bytes = Checksum
    }
}
