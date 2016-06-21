//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

public struct Voltage: FloatLiteralConvertible {
    
    var volt: Float
    var milliVolt: Float
    
    public init(floatLiteral value:Float) {
        milliVolt = value
        volt = value / 1000
    }
    
    public init(volt value: Float) {
        volt = value
        milliVolt = value * 1000
    }
    
    public init(milliVolt value: Float) {
        milliVolt = value
        volt = value / 1000
    }
    
    var formatted: String {
        return "\(self.volt) V"
    }
}
