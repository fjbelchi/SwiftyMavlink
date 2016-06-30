import Foundation

class MyDelegate : MavlinkParserDelegate {
    func parser(parser: MavlinkParser, didReceivePacket packet: Packet, channel: Channel) {
        print("didReceivePacket packet: \(packet.messageId)")
    }
    
    func parser(parser: MavlinkParser, didFailToReceivePacketWithError error: ErrorProtocol, data: Packet?, channel: Channel) {
        print("didFailToReceivePacketWithError: data: \(data), error: \(error)")
    }
    
    func parser(parser: MavlinkParser, didParseMessage message: Message, fromPacket packet: Packet, channel: Channel) {
//        print("didParseMessage message: \(message)")
        if let heartbeat = message as? Heartbeat {
            print("heartbeat autopilot: \(heartbeat.autopilot), type: \(heartbeat.type), baseMode: \(heartbeat.baseMode)")
        } else if let systemStatus = message as? SystemStatus {
            print("systemStatus: voltage \(systemStatus.voltageBattery)")
        } else if let systemTime = message as? SystemTime {
            print("systemTime: \(systemTime)")
        } else if let ping = message as? Ping {
            print("ping: \(ping)")
        }
    }
    
    func parser(parser: MavlinkParser, didFailToParseMessageFromPacket packet: Packet, withError error: ErrorProtocol, channel: Channel) {
        print("didFailToParseMessageFromPacket: \(packet.messageId)")
    }
    
}
