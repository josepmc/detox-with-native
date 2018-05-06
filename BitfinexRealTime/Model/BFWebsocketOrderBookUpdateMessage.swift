//
//  BFWebsocketOrderBookUpdateMessage.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 07.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation

/// The Order Books channel allow you to keep track of the state of the Bitfinex order book.
/// It is provided on a price aggregated basis, with customizable precision.
/// After receiving the response, you will receive a snapshot of the book,
/// followed by updates upon any changes to the book.

///
/// Example Message:
/// [
///   CHANNEL_ID,
///   [ [PRICE, COUNT, AMOUNT], [PRICE, COUNT, AMOUNT], [PRICE, COUNT, AMOUNT], ... ]
/// ]
///  PRICE = Price level (float)
///  COUNT = Number of orders at that price level (int)
///  ±AMOUNT = Total amount available at that price level (float). if AMOUNT > 0 then bid else ask
///
/// Algorithm to create and keep a book instance updated
///
/// 1. subscribe to channel
/// 2. receive the book snapshot and create your in-memory book structure
/// 3. when count > 0 then you have to add or update the price level
///    * if amount > 0 then add/update bids
///    * if amount < 0 then add/update asks
/// 4. when count = 0 then you have to delete the price level.
///    * if amount = 1 then remove from bids
///    * if amount = -1 then remove from asks
///
struct BFWebsocketOrderBookUpdateMessage: BFWebsocketMessage {
    
    // Receiving an array of array of numbers is = receiving the order book snapshot
    private typealias OrderBookSnapshot = [[NSNumber]]
    
    // Receiving just 1 single array of numbers is = receiving an order book update
    private typealias OrderBookUpdate = [NSNumber]
    
    /// The indexes used to access the values we need in the received array
    private let PriceIndex = 0
    private let CountIndex = 1
    private let AmountIndex = 2
    
    var responseType: BitfinexWebsocketMessageType {
        return .channelUpdate
    }
    let channelId: Int
    
    // The entries received in this order book update
    var orderBookEntries = [OrderBookEntry]()

    init?(withJson jsonObject: ChannelMessage) {
        
        // Intergrity checks on the received json
        guard jsonObject.count > 1 else {
            // If the array does not have a second element we return
            return nil
        }
        
        // We can now access and store all our properties
        guard let chanId = jsonObject.first as? Int else {
            return nil
        }
        channelId = chanId
        
        if let orderBookSnapshot = jsonObject[1] as? OrderBookSnapshot {
            for entry in orderBookSnapshot {
                let orderBookEntry = OrderBookEntry(price: entry[PriceIndex].floatValue,
                                                    count: entry[CountIndex].intValue,
                                                    amount: entry[AmountIndex].floatValue)
                orderBookEntries.append(orderBookEntry)
            }
        } else if let orderBookUpdate = jsonObject[1] as? OrderBookUpdate {
            let orderBookEntry = OrderBookEntry(price: orderBookUpdate[PriceIndex].floatValue,
                                                count: orderBookUpdate[CountIndex].intValue,
                                                amount: orderBookUpdate[AmountIndex].floatValue)
            orderBookEntries.append(orderBookEntry)
        } else {
            return nil
        }
    }
}

struct OrderBookEntry: CustomStringConvertible {
    let price: Float
    let count: Int
    let amount: Float
    
    var description: String {
        return "ORDER BOOK ENTRY: price:\(price), count:\(count), amount:\(amount)"
    }
    
    var isBid: Bool {
        return amount >= 0
    }
}
