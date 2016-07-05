//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation
import Mavlink

/// Request to control this MAV
public struct ChangeOperatorControl {
    
    enum ControlRequest: UInt8 {
        case Take = 0
        case Release
    }
    
    let targetSystem: UInt8
    let controlRequest: ControlRequest
    let version: UInt8
    let passKey: String
}

extension ChangeOperatorControl: Message {
    
    public static func messageId() -> UInt8 {
        return 5
    }
    
    public static func systemId() -> UInt8 {
        return 0
    }
    
    public static func componentId() -> UInt8 {
        return 0
    }
    
    public static func messageLength() -> UInt8 {
        return 28
    }
    
    public static func CRSsExtra() -> UInt8 {
        return 217
    }
    
    public init(data: Data) throws {
        self.targetSystem = try data.mavNumber(offset: 0)
        self.controlRequest = try data.mavNumber(offset: 1)
        self.version = try data.mavNumber(offset: 2)
        self.passKey = data.mavString(offset: 3, length: 25)
    }
}

extension ChangeOperatorControl: MavlinkEncodeMessage {
    
    public func encode() -> [UInt8] {

        var message = mavlink_message_t()
        mavlink_msg_change_operator_control_pack(SystemStatus.messageId(),
                              SystemStatus.componentId(),
                              &message,
                              self.targetSystem,
                              self.controlRequest.rawValue,
                              self.version,
                              self.passKey)
        
        let buffer = [UInt8](repeating:0, count: SystemStatus.length())
        
        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(buffer)
        mavlink_msg_to_send_buffer(pointer, &message)
        
        return buffer
    }
}
