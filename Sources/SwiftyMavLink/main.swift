import Foundation
import Darwin
import Socks
import Mavlink

let address = InternetAddress.localhost(port: 14550)

while true {
    do {
        let client = try UDPClient(address: address)
        
        var hearbeat = Heartbeat(type: .Quadrotor, autopilot: .ArdupilotMega, baseMode: .StabilizeEnabled, customMode: 0, systemStatus: .StandBy, version: .Official)
        
        let bytes = hearbeat.encode()
        try client.send(bytes: bytes)
        
        let (data, sender) = try client.receive()
        
        let recvData = NSData(bytes: data, length: data.count)
        
        let parser = MavlinkParser()
        parser.delegate = MyDelegate()
        
        parser.appendData(data: recvData as Data, channel: 0)
        
        //    try client.close()
        
        let str = try data.toString()
        let senderStr = String(sender)
        print("Received: \n\(str) from \(senderStr)")
    } catch {
        print("Error \(error)")
    }
    
}
