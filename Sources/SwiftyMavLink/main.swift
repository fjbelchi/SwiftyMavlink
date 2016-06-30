import Foundation
import Socks

let address = InternetAddress.localhost(port: 14550)

while true {
    do {
        let client = try UDPClient(address: address)
        
        var hearbeat = Heartbeat(type: .Quadrotor, autopilot: .ArdupilotMega, baseMode: [.CustomEnabled, .SafetyArmed], customMode: 0, systemStatus: .StandBy, version: .Official)
        
        let bytes = hearbeat.encode()
        try client.send(bytes: bytes)
        
        let (data, sender) = try client.receive()
        
        let recvData = NSData(bytes: data, length: data.count)
        
        let parser = MavlinkParser()
        parser.delegate = MyDelegate()
        
        parser.appendData(data: recvData as Data, channel: 0)
        
        var status = SystemStatus(controlSensorPresent: .All, controlSensorEnabled: .All, controlSensorHealth: .All, load: 50, voltageBattery: 3, currentBattery: 2, batteryRemaining: 50, communicationDropRate: 0, communicationError: 0, errorCount1: 0, errorCount2: 0, errorCount3: 0, errorCount4: 0)
        
        try client.send(bytes: status.encode())
        
        var ping = Ping(pingSequence: 0, targetSystem: 0, targetComponent: 0)
        try client.send(bytes: ping.encode())
        
        let str = try data.toString()
        let senderStr = String(sender)
        print("Received: \n\(str) from \(senderStr)")
    } catch {
        print("Error \(error)")
    }
    
}
