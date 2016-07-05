//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

extension UInt32 {
    var asByteArray: [UInt8] {
        return [0, 8, 16, 24]
            .map { UInt8(self >> $0 & 0x000000FF) }
    }
}

extension Int {
    public var toU8: UInt8 { get { return UInt8(truncatingBitPattern:self) } }
    public var to8: Int8 { get { return Int8(truncatingBitPattern:self) } }
    public var toU16: UInt16 { get { return UInt16(truncatingBitPattern:self) } }
    public var to16: Int16 { get { return Int16(truncatingBitPattern:self) } }
    public var toU32: UInt32 { get { return UInt32(truncatingBitPattern:self) } }
    public var to32: Int32 { get { return Int32(truncatingBitPattern:self) } }
    public var toU64: UInt64 { get {
        return UInt64(self) //No difference if the platform is 32 or 64
        }}
    public var to64: Int64 { get {
        return Int64(self) //No difference if the platform is 32 or 64
        }}
}

extension Int32 {
    public var toU8: UInt8 { get { return UInt8(truncatingBitPattern:self) } }
    public var to8: Int8 { get { return Int8(truncatingBitPattern:self) } }
    public var toU16: UInt16 { get { return UInt16(truncatingBitPattern:self) } }
    public var to16: Int16 { get { return Int16(truncatingBitPattern:self) } }
    public var toU32: UInt32 { get { return UInt32(self) } }
    public var to32: Int32 { get { return self }}
    public var toU64: UInt64 { get {
        return UInt64(self) //No difference if the platform is 32 or 64
        }}
    public var to64: Int64 { get {
        return Int64(self) //No difference if the platform is 32 or 64
        }}
}
