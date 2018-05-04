//
//  BitfinexWSResponse.swift.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 04.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation

/// All the possible responses type from a Bitfinex Websocket
enum BitfinexWebsocketMessageType {
    case info
    case pong
    case configuration
    case channelSubscription
    case channelUnsubscription
    case channelUpdate
    case channelHeartbeating
    case error
}

protocol BitfinexWebsocketMessage {
    /// The type of response (see BitfinexWSResponseType)
    var responseType: BitfinexWebsocketMessageType { get }
}

typealias EventMessage = [String: Any]

///
/// BitfinexWebsocketInfoMessage
///
/// Info messages are sent from the websocket server to notify the state of your connection.
/// Right after connecting you will receive an info message that contains the actual version
/// of the websocket stream, along with a platform status flag (1 for operative, 0 for maintenance).
///
/// Example
/// { "event": "info", "version":  VERSION, "platform": { "status": 1 } }
///
struct BitfinexWebsocketInfoMessage: BitfinexWebsocketMessage {
    
    var responseType: BitfinexWebsocketMessageType {
        return .info
    }
    var platformIsOperative: Bool {
        return platformStatus == 1
    }
    
    let socketStreamVersion: Int
    let platformStatus: Int

    init?(withJson jsonObject: EventMessage) {

        guard let version = jsonObject["version"] as? Int else {
            return nil
        }
        guard let platform = jsonObject["platform"] as? [String: Int], let status = platform["status"] else {
            return nil
        }
        socketStreamVersion = version
        platformStatus = status
    }
}

