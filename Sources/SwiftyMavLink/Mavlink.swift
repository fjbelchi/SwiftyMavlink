import Foundation
import Mavlink

final public class Mavlink {

  public enum Message {
    case Heartbeat(type: UInt8, autopilot: UInt8, baseMode: UInt8, customMode: UInt32, systemStatus: UInt8, version: UInt8)
    case SystemStatus
  }

  class func parse(data: NSData, channel: UInt8 = UInt8(MAVLINK_COMM_1.rawValue)) -> Message? {
    var bytes = [UInt8](repeating:0, count:data.length)
    data.getBytes(&bytes, length: data.length)

    for byte in bytes {
        var message = mavlink_message_t()
        var status = mavlink_status_t()
        if mavlink_parse_char(channel, byte, &message, &status) != 0 {
          return Mavlink.decode(message: &message)
        }
    }
    return nil
  }

  class func encode(message: Message) -> NSData? {
    return nil // TODO
  }

  private class func decode(message: inout mavlink_message_t) -> Message? {
    switch message.msgid {
    case 0:
        var heartbeat = mavlink_heartbeat_t()
        mavlink_msg_heartbeat_decode(&message, &heartbeat);
        return Message.Heartbeat(type: heartbeat.type,
                                 autopilot: heartbeat.autopilot,
                                 baseMode: heartbeat.base_mode,
                                 customMode: heartbeat.custom_mode,
                                 systemStatus: heartbeat.system_status,
                                 version: heartbeat.mavlink_version)
    default:
        return nil
    }
  }

}

extension Mavlink.Message {

  var id: Int {
    switch self {
      case .Heartbeat:
        return 0
      case .SystemStatus:
        return 1
    }
  }

  var description: String {
    switch self {
      case let Heartbeat(type, autopilot, baseMode, customMode, systemStatus, version):
        return "HEARTBEAT: " +
                          "type: \(type), " +
                          "autopilot: \(autopilot), " +
                          "baseMode: \(baseMode), " +
                          "customMode: \(customMode), " +
                          "systemStatus: \(systemStatus), " +
                          "version: \(version)"
      case let SystemStatus:
        return "SystemStatus"
    }
  }

}
