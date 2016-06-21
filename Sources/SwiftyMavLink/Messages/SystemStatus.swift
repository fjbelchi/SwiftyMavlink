//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation
import Mavlink

struct SystemStatus {
    // -- Sensors
    let controlSensorPresent: Mavlink.SystemStatusSensor
    let controlSensorEnabled: Mavlink.SystemStatusSensor
    let controlSensorHealth: Mavlink.SystemStatusSensor
    
    // -- Battery
    let load: UInt16 // Maximum usage in percent of the mainloop time, (0%: 0, 100%: 1000) should be always below 1000
    let voltageBattery: UInt16 // Battery voltage, in millivolts (1 = 1 millivolt)
    let currentBattery: Int16 // Battery current, in 10*milliamperes (1 = 10 milliampere), -1: autopilot does not measure the current
    let batteryRemaining: Int8 // Remaining battery energy: (0%: 0, 100%: 100), -1: autopilot estimate the remaining battery
    
    // -- Communication
    
    /// Communication drops in percent, (0%: 0, 100%: 10'000)
    let communicationDropRate: UInt16
    let communicationError: UInt16
    
    // -- Error
    /// Autopilot-specific errors
    let errorCount1: UInt16
    let errorCount2: UInt16
    let errorCount3: UInt16
    let errorCount4: UInt16
}

extension SystemStatus: Message {
    
    static func messageId() -> UInt8 {
        return 1
    }
    
    static func systemId() -> UInt8 {
        return 0
    }
    
    static func componentId() -> UInt8 {
        return 0
    }
    
    static func messageLength() -> UInt8 {
        return 31
    }
    
    static func CRSsExtra() -> UInt8 {
        return 124
    }
    
    init(data: Data) throws {
        self.controlSensorPresent = try data.mavNumber(offset: 0)
        self.controlSensorEnabled = try data.mavNumber(offset: 4)
        self.controlSensorHealth = try data.mavNumber(offset: 8)
        self.load = try data.mavNumber(offset: 12)
        self.voltageBattery = try data.mavNumber(offset: 14)
        self.currentBattery = try data.mavNumber(offset: 16)
        self.communicationDropRate = try data.mavNumber(offset: 18)
        self.communicationError = try data.mavNumber(offset: 20)
        self.errorCount1 = try data.mavNumber(offset: 22)
        self.errorCount2 = try data.mavNumber(offset: 24)
        self.errorCount3 = try data.mavNumber(offset: 26)
        self.errorCount4 = try data.mavNumber(offset: 28)
        self.batteryRemaining = try data.mavNumber(offset: 30)
    }
}

extension SystemStatus: MavlinkEncodeMessage {
    
    func encode() -> [UInt8] {
        
        var message = mavlink_message_t()
        mavlink_msg_sys_status_pack(SystemStatus.messageId(),
                                    SystemStatus.componentId(),
                                    &message,
                                    self.controlSensorPresent.rawValue,
                                    self.controlSensorEnabled.rawValue,
                                    self.controlSensorHealth.rawValue,
                                    self.load,
                                    self.voltageBattery,
                                    self.currentBattery,
                                    self.batteryRemaining,
                                    self.communicationDropRate,
                                    self.communicationError,
                                    self.errorCount1,
                                    self.errorCount2,
                                    self.errorCount3,
                                    self.errorCount4)
        
        let buffer = [UInt8](repeating:0, count: SystemStatus.length())
        
        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(buffer)
        mavlink_msg_to_send_buffer(pointer, &message);
        
        return buffer
    }
}
