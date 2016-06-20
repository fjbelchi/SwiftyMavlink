import Foundation

class MyDelegate : MavlinkParserDelegate {
    func parser(parser: MavlinkParser, didReceivePacket packet: Packet, channel: Channel) {
        print("didReceivePacket packet: \(packet.messageId)")
    }
    
    func parser(parser: MavlinkParser, didFailToReceivePacketWithError error: ErrorProtocol, data: Packet?, channel: Channel) {
        print("didFailToReceivePacketWithError: data: \(data), error: \(error)")
    }
    
    func parser(parser: MavlinkParser, didParseMessage message: Message, fromPacket packet: Packet, channel: Channel) {
        print("didParseMessage message: \(message)")
        if let heartbeat = message as? Heartbeat {
            print("heartbeat autopilot: \(heartbeat.autopilot), type: \(heartbeat.type), baseMode: \(heartbeat.baseMode)")
        }
    }
    
    func parser(parser: MavlinkParser, didFailToParseMessageFromPacket packet: Packet, withError error: ErrorProtocol, channel: Channel) {
        print("didFailToParseMessageFromPacket: \(packet.messageId)")
    }
    
}
