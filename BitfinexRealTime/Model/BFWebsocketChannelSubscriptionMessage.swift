//
//  BitfinexWebsocketTickerSubscriptionMessage.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 05.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation


///
/// Example
/// { event: "subscribed", channel: "ticker", chanId: CHANNEL_ID, pair: "BTCUSD" }
///
struct BFWebsocketChannelSubscriptionMessage: BFWebsocketMessage {
    
    var responseType: BitfinexWebsocketMessageType {
        return .channelSubscription
    }
    
    let channelId: Int
    let channelName: String
    let symbol: String
    
    init?(withJson jsonObject: EventMessage) {
        
        guard let chanId = jsonObject["chanId"] as? Int else {
            return nil
        }
        guard let chanName = jsonObject["channel"] as? String else {
            return nil
        }
        guard let tickerSymbol = jsonObject["pair"] as? String else {
            return nil
        }
        channelId = chanId
        symbol = tickerSymbol
        channelName = chanName
    }
}
