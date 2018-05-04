//
//  BitfinexWSTickerChannel.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 04.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation

/// The BitfinexWSTickerChannel class let us interact with the Bitfinex WS Ticker Channel
///
class BitfinexWSTickerChannel: NSObject {
    
    var channelName: String {
        return "ticker"
    }
    
    func subscriptionRequest(forSymbol symbol: String) -> String? {
        let subscriptionRequest = ["event": "subscribe", "channel": channelName, "symbol": symbol]
        let jsonData = try? JSONSerialization.data(withJSONObject: subscriptionRequest, options: .prettyPrinted)
        guard let jsonDataNotNil = jsonData else {
            return nil
        }
        return String(data: jsonDataNotNil, encoding: .utf8)
    }
}
