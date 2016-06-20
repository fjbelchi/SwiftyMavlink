//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation
import Mavlink

struct Heartbeat {
    let type: Mavlink.MavType
    let autopilot: Mavlink.Autopilot
    let baseMode: Mavlink.ModeFlag
    let customMode: UInt32
    let systemStatus: Mavlink.State
    let version: Mavlink.Version
}

extension Heartbeat: Message {
    
    static func messageId() -> UInt8 {
        return 0
    }

    static func systemId() -> UInt8 {
        return 0
    }

    static func componentId() -> UInt8 {
        return 0
    }

    static func length() -> UInt8 {
        return 9
    }
    
    static func CRSsExtra() -> UInt8 {
        return 50
    }
    
    init(data: Data) throws {
        self.customMode = try data.mavNumber(offset: 0)
        self.type = try data.mavNumber(offset: 4)
        self.autopilot = try data.mavNumber(offset: 5)
        self.baseMode = try data.mavNumber(offset: 6)
        self.systemStatus = try data.mavNumber(offset: 7)
        self.version = try data.mavNumber(offset: 8)
    }
}

extension Heartbeat: MavlinkEncodeMessage {
    
    func encode() -> [UInt8] {
        
        var message = mavlink_message_t()
        mavlink_msg_heartbeat_pack(0, 0, &message,self.type.rawValue, self.autopilot.rawValue, self.baseMode.rawValue, self.customMode, self.systemStatus.rawValue)
        
        let buffer = [UInt8](repeating:0, count: 17)
        
        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(buffer)
        mavlink_msg_to_send_buffer(pointer, &message);
        
        return buffer
    }
}
