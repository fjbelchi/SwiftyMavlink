//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

public protocol MavlinkEncodeMessage {
    func encode() -> [UInt8]
}

public protocol Message: MavlinkEncodeMessage {
    var messageId: UInt8 { get }
    var systemId: UInt8 { get }
    var componentId: UInt8 { get }
    
    init(data: Data) throws
}







// public enum Message {
//   case Heartbeat(type: Mavlink.MavType, autopilot: Mavlink.Autopilot, baseMode: Mavlink.ModeFlag, customMode: UInt32, systemStatus: Mavlink.State, version: Mavlink.Version)
//   case SystemStatus
// }
//
// extension Message {
//
//   var id: Int {
//     switch self {
//       case .Heartbeat:
//         return 0
//       case .SystemStatus:
//         return 1
//     }
//   }
//
//   var description: String {
//     switch self {
//       case let Heartbeat(type, autopilot, baseMode, customMode, systemStatus, version):
//         return "HEARTBEAT: "
//         //  +
//         //                   "type: \(type), " +
//         //                   "autopilot: \(autopilot), " +
//         //                   "baseMode: \(baseMode), " +
//         //                   "customMode: \(customMode), " +
//         //                   "systemStatus: \(systemStatus), " +
//         //                   "version: \(version)"
//       case let SystemStatus:
//         return "SystemStatus"
//     }
//   }
//
// }
