//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

/// Data extension with methods for getting proper typed values from received data
public extension Data {
    
    /**
     Returns Number value (integer and floating point) from data
     
     - Parameter offset: Offset in data bytes
     - Warning: Throws `ParserError`
     - Returns: `T`
     */
    func mavNumber<T>(offset: Int) throws -> T {
        let size = strideof(T.self)
        guard offset + size <= count else {
            throw MavlinkParserError.NumberSizeOutOfBounds(offset: offset, size: size)
        }
        
        var bytes = [UInt8](repeating: 0, count: size)
//        getBytes(&bytes, range: NSRange(location: offset, length: size))
        let range: Range<Int> = offset..<offset+size
        self.copyBytes(to: &bytes, from: range)
        
        if CFByteOrderGetCurrent() != Int(CFByteOrderLittleEndian.rawValue) {
            bytes = bytes.reversed()
        }
        
        return bytes.withUnsafeBufferPointer {
            return UnsafePointer<T>($0.baseAddress!).pointee
        }
    }
    
    /**
     Returns typed array from data
     
     - Parameter offset: Offset in data bytes
     - Parameter count: Number of elements in array
     
     - Warning: Throws `ParserError`
     
     - Returns: `Array<T>`
     */
    func mavArray<T>(offset: Int, count: Int) throws -> Array<T> {
        var offset = offset
        var array: [T] = [T]()
        for _ in 0..<count {
            array.append(try mavNumber(offset: offset))
            offset += strideof(T.self)
        }
        return array
    }
    
    /**
     Returns ASCII String from data
     
     - Parameter offset: Offset in data bytes
     - Parameter length: Length of string to read
     
     - Returns: `String`
     */
    func mavString(offset: Int, length: Int) -> String {
        let range: Range<Int> = offset..<length
        let string = NSString(data: subdata(in: range), encoding: String.Encoding.ascii.rawValue) ?? ""
        return string as String
    }
    
    /**
     Returns proper Enum from data or throws UnknownEnumValue error
     
     - Parameter offset: Offset in data bytes
     
     - Warning: Throws `ParserEnumError`
     
     - Returns: `T: RawRepresentable`
     */
//    func mavEnumeration<T: RawRepresentable>(offset: Int) throws -> T {
//        let int: T.RawValue = try mavNumber(offset: offset)
//        if let enumeration = T(rawValue: int) {
//            return enumeration
//        }
//        throw MavlinkParserError.UnknownValue(enumType: T.self, rawValue: int, valueOffset: offset)
//    }
}
