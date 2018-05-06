//
//  BFWebsocketMessage.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 04.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation

/// All the possible responses type from a Bitfinex Websocket
enum BitfinexWebsocketMessageType {
    case info
    case pong // not treated (we don't ping on this project for the moment)
    case channelSubscription
    case channelUnsubscription // not treated (we will not unsubscribe on this project for the moment)
    case channelUpdate
    case channelHeartbeating
    case error
}

protocol BFWebsocketMessage {
    /// The type of response (see BitfinexWSResponseType)
    var responseType: BitfinexWebsocketMessageType { get }
}

// On Bitfinex an event message is a dictionary of elements
typealias EventMessage = [String: Any]

// On Bitfinex a channel message is an array of elements
typealias ChannelMessage = [Any]
