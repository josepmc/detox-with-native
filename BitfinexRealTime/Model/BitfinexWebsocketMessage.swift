//
//  BitfinexWebsocketMessage.swift
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
