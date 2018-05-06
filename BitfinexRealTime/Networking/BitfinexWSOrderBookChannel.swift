//
//  BitfinexWSOrderBookChannel.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 06.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

/// The Order Books channel allow you to keep track of the state of the Bitfinex order book.
/// After receiving the response, you will receive a snapshot of the book,
/// followed by updates upon any changes to the book.
class BitfinexWSOrderBookChannel: NSObject {
    
    static var channelName: String {
        return "book"
    }
    
    func orderBookSubscriptionMessage(forSymbol symbol: String) -> String? {
        let subscriptionMessage = ["event": "subscribe",
                                   "channel": BitfinexWSOrderBookChannel.channelName,
                                   "symbol": symbol,
                                   "len": "25" ]
        let jsonData = try? JSONSerialization.data(withJSONObject: subscriptionMessage, options: .prettyPrinted)
        guard let jsonDataNotNil = jsonData else {
            return nil
        }
        return String(data: jsonDataNotNil, encoding: .utf8)
    }
}
