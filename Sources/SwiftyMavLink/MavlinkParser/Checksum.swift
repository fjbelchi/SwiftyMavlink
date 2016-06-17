//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

///Struct for storing and calculating checksum
public struct Checksum {
    
    struct Constants {
        static let X25InitCRCValue: UInt16 = 0xFFFF
    }
    
    public private(set) var value: UInt16 = 0
    
    public var lowByte: UInt8 {
        return UInt8(truncatingBitPattern: value)
    }
    public var highByte: UInt8 {
        return UInt8(truncatingBitPattern: value >> 8)
    }
    
    init() {
        start()
    }
    
    /**
     Initiliaze the buffer for the X.25 CRC
     
     - Returns: `Void`
     */
    mutating func start() {
        value = Constants.X25InitCRCValue
    }
    
    /**
     Accumulate the X.25 CRC by adding one char at a time. The checksum function adds the hash of one char at a time to the 16 bit checksum `value` (`UInt16`).
     
     - Parameter char: New char to hash
     
     - Returns: `Void`
     */
    mutating func accumulateChar(char: UInt8) {
        var tmp: UInt8 = char ^ UInt8(truncatingBitPattern: value)
        tmp ^= (tmp << 4)
        value = (UInt16(value) >> 8) ^ (UInt16(tmp) << 8) ^ (UInt16(tmp) << 3) ^ (UInt16(tmp) >> 4)
    }
}
