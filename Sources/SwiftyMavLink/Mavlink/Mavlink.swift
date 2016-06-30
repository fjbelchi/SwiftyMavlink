//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation

public struct Mavlink {
    
    public static let messages: [UInt8: Message.Type] = [
        Heartbeat.messageId(): Heartbeat.self,
        SystemStatus.messageId(): SystemStatus.self,
        SystemTime.messageId(): SystemTime.self,
        Ping.messageId(): Ping.self
    ]
}
