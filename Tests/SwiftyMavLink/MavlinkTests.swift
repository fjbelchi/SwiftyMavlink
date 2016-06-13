@testable
import SwiftyMavLink
import Mavlink
import XCTest

class MavlinkTests: XCTestCase {
  let mavlink = Mavlink()

  func testExample(){
    var message = mavlink_message_t()
    mavlink_msg_heartbeat_pack(0,0,&message,0,1,2,3,4);

    let mavMsg = Mavlink.decode(message: &message)
    print(mavMsg?.description)
    XCTAssertTrue(true)
  }

  public func descriptionForMavlinkMessage(message: inout mavlink_message_t) -> String {
      var description: String
      switch message.msgid {
      case 0:
          var heartbeat = mavlink_heartbeat_t()
          mavlink_msg_heartbeat_decode(&message, &heartbeat);
          description = "HEARTBEAT mavlink_version: \(heartbeat.mavlink_version), type: \(heartbeat.type), autopilot: \(heartbeat.autopilot)"
      case 1:
          var sys_status = mavlink_sys_status_t()
          mavlink_msg_sys_status_decode(&message, &sys_status)
          description = "SYS_STATUS comms drop rate: \(sys_status.drop_rate_comm)%"
      case 30:
          var attitude = mavlink_attitude_t()
          mavlink_msg_attitude_decode(&message, &attitude)
          description = "ATTITUDE roll: \(attitude.roll) pitch: \(attitude.pitch) yaw: \(attitude.yaw)"
      case 32:
          description = "LOCAL_POSITION_NED"
      case 33:
          description = "GLOBAL_POSITION_INT"
      case 74:
          var vfr_hud = mavlink_vfr_hud_t()
          mavlink_msg_vfr_hud_decode(&message, &vfr_hud)
          description = "VFR_HUD heading: \(vfr_hud.heading) degrees"
      case 87:
          description = "POSITION_TARGET_GLOBAL_INT:"
      case 105:
          var highres_imu = mavlink_highres_imu_t()
          mavlink_msg_highres_imu_decode(&message, &highres_imu)
          description = "HIGHRES_IMU Pressure: \(highres_imu.abs_pressure) millibar"
      case 147:
          var battery_status = mavlink_battery_status_t()
          mavlink_msg_battery_status_decode(&message, &battery_status)
          description = "BATTERY_STATUS current consumed: \(battery_status.current_consumed) mAh"
      default:
          description = "OTHER Message id \(message.msgid) received"
      }

      return "\(description)\n"
  }

}
