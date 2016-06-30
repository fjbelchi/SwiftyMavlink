//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation
import Mavlink

/// The system time is the time of the master clock, typically the computer clock of the main onboard computer.
public struct SystemTime {
    let timestamp: Date
    let bootTime: Date
    
    public init() {
        self.timestamp = Date()
        self.bootTime = Date(timeIntervalSinceReferenceDate: ProcessInfo.processInfo().systemUptime)
    }
}

extension SystemTime: Message {
    
    public static func messageId() -> UInt8 {
        return 2
    }
    
    public static func systemId() -> UInt8 {
        return 0
    }
    
    public static func componentId() -> UInt8 {
        return 0
    }
    
    public static func messageLength() -> UInt8 {
        return 12
    }
    
    public static func CRSsExtra() -> UInt8 {
        return 137
    }
    
    public init(data: Data) throws {
        let unixTimestamp: UInt64 = try data.mavNumber(offset: 0)
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let bootTimestamp: UInt32 = try data.mavNumber(offset: 8)
        self.bootTime = Date(timeIntervalSince1970: TimeInterval(bootTimestamp))
    }
}

extension SystemTime: MavlinkEncodeMessage {
    
    public func encode() -> [UInt8] {
        
        let unixTimestamp = UInt64(self.timestamp.timeIntervalSince1970)
        let bootTimestamp = UInt32(ProcessInfo.processInfo().systemUptime*1000)
        
        var message = mavlink_message_t()
        mavlink_msg_system_time_pack(SystemStatus.messageId(),
                                    SystemStatus.componentId(),
                                    &message,
                                    unixTimestamp,
                                    bootTimestamp)
        
        let buffer = [UInt8](repeating:0, count: SystemStatus.length())
        
        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(buffer)
        mavlink_msg_to_send_buffer(pointer, &message);
        
        return buffer
    }
}
