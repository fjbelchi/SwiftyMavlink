//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation
import Mavlink

/// A ping message either requesting or responding to a ping. This allows to measure the system latencies, including serial port, radio modem and UDP connections.
public struct Ping {
    
    let timestamp: Date
    let pingSequence: UInt32
    let targetSystem: UInt8
    let targetComponent: UInt8
    
    public init(pingSequence: UInt32, targetSystem: UInt8, targetComponent: UInt8) {
        self.timestamp = Date(timeIntervalSinceReferenceDate: ProcessInfo.processInfo().systemUptime)
        self.pingSequence = pingSequence
        self.targetSystem = targetSystem
        self.targetComponent = targetComponent
    }
}

extension Ping: Message {
    
    public static func messageId() -> UInt8 {
        return 4
    }
    
    public static func systemId() -> UInt8 {
        return 0
    }
    
    public static func componentId() -> UInt8 {
        return 0
    }
    
    public static func messageLength() -> UInt8 {
        return 14
    }
    
    public static func CRSsExtra() -> UInt8 {
        return 237
    }
    
    public init(data: Data) throws {
        let timestamp: UInt64 = try data.mavNumber(offset: 0)
        self.timestamp = Date(timeIntervalSinceReferenceDate: TimeInterval(timestamp))
        self.pingSequence = try data.mavNumber(offset: 8)
        self.targetSystem = try data.mavNumber(offset: 12)
        self.targetComponent = try data.mavNumber(offset: 13)
    }
}

extension Ping: MavlinkEncodeMessage {
    
    public func encode() -> [UInt8] {
        
        let timestamp = UInt64(ProcessInfo.processInfo().systemUptime)
        
        var message = mavlink_message_t()
        mavlink_msg_ping_pack(SystemStatus.messageId(),
                                     SystemStatus.componentId(),
                                     &message,
                                     timestamp,
                                     self.pingSequence,
                                     self.targetSystem,
                                     self.targetComponent)
        
        let buffer = [UInt8](repeating:0, count: SystemStatus.length())
        
        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(buffer)
        mavlink_msg_to_send_buffer(pointer, &message);
        
        return buffer
    }
}
