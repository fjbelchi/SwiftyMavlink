//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

import Foundation
import Mavlink

public struct RequestDataStream {

    enum SendingStatus: Int {
        case Stop = 0
        case Start
    }

    let targetSystem: UInt8
    let targetComponent: UInt8
    let requestStreamId: UInt8
    let requestMessageRate: UInt16
    let sendingStatus: SendingStatus
}

extension RequestDataStream: Message {

    public static func messageId() -> UInt8 {
        return 66
    }

    public static func systemId() -> UInt8 {
        return 0
    }

    public static func componentId() -> UInt8 {
        return 0
    }

    public static func messageLength() -> UInt8 {
        return 6
    }

    public static func CRSsExtra() -> UInt8 {
        return 148
    }

    public init(data: Data) throws {
        self.requestMessageRate = try data.mavNumber(offset: 0)
        self.targetSystem = try data.mavNumber(offset: 2)
        self.targetComponent = try data.mavNumber(offset: 3)
        self.requestStreamId = try data.mavNumber(offset: 4)
        self.sendingStatus = try data.mavNumber(offset: 5)
    }
}

extension RequestDataStream: MavlinkEncodeMessage {

    public func encode() -> [UInt8] {

        let sendingStatus = UInt8(self.sendingStatus.rawValue)

        var message = mavlink_message_t()
        mavlink_msg_request_data_stream_pack(SystemStatus.messageId(),
                              SystemStatus.componentId(),
                              &message,
                              self.targetSystem,
                              self.targetComponent,
                              self.requestStreamId,
                              self.requestMessageRate,
                              sendingStatus)

        let buffer = [UInt8](repeating:0, count: SystemStatus.length())

        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(buffer)
        mavlink_msg_to_send_buffer(pointer, &message)

        return buffer
    }
}
