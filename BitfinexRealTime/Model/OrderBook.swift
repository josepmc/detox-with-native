//
//  OrderBook.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 07.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

struct OrderBookEntry: CustomStringConvertible {
    let price: Float
    let count: Int
    let amount: Float
    
    var description: String {
        return "ORDER BOOK ENTRY: price:\(price), count:\(count), amount:\(amount)"
    }
    
    var isBuyOrder: Bool {
        return amount >= 0
    }
}

class OrderBook: NSObject {

    var buyOrders: [OrderBookEntry]
    var sellOrders: [OrderBookEntry]
    
    var sortedBuyOrders: [OrderBookEntry] {
        // Sell orders are sorted with price from high to low
        return buyOrders.sorted(by: { $0.price > $1.price })
    }

    var sortedSellOrders: [OrderBookEntry] {
        // Sell orders are sorted with price from low to high
        return sellOrders.sorted(by: { $0.price < $1.price })
    }
    
    init(orderBookEntries entries: [OrderBookEntry]) {
        buyOrders = [OrderBookEntry]()
        sellOrders = [OrderBookEntry]()
        
        for entry in entries {
            if entry.isBuyOrder {
                buyOrders.append(entry)
            } else {
                sellOrders.append(entry)
                
            }
        }
    }
    
    /// Algorithm to keep a book instance updated
    ///
    /// for each entry in the update, evaluate "count"
    ///
    /// if count > 0 then you have to add or update the price level
    ///    * if amount > 0 then add/update bids
    ///    * if amount < 0 then add/update asks
    /// if count = 0 then you have to delete the price level.
    ///    * if amount = 1 then remove from bids
    ///    * if amount = -1 then remove from asks
    ///

    // Update Order
    func update(withEntries orderBookEntries: [OrderBookEntry]) {
        
        for entryToUpdate in orderBookEntries {
            
            let count = entryToUpdate.count
            let amount = entryToUpdate.amount
            
            if count == 0 {
                // ---------------
                // REMOVE FROM BOOK
                // ---------------
                if amount == 1 {
                    // Remove from bids (buys)
                    if let indexOfObjectToRemove = buyOrders.index(where: {$0 == entryToUpdate}) {
                        buyOrders.remove(at: indexOfObjectToRemove)
                    }
                } else if amount == -1 {
                    // Remove from asks (sells)
                    if let indexOfObjectToRemove = sellOrders.index(where: {$0 == entryToUpdate}) {
                        sellOrders.remove(at: indexOfObjectToRemove)
                    }
                }
            } else if count > 0{
                // ---------------
                // UPDATE IN BOOK
                // ---------------
                if amount > 0 {
                    // Add or update bids (buys)
                    if let indexOfObjectToUpdate = buyOrders.index(where: {$0 == entryToUpdate}) {
                        buyOrders[indexOfObjectToUpdate] = entryToUpdate
                    } else {
                        buyOrders.append(entryToUpdate)
                    }
                } else {
                    // add or update asks (sells)
                    if let indexOfObjectToUpdate = sellOrders.index(where: {$0 == entryToUpdate}) {
                        sellOrders[indexOfObjectToUpdate] = entryToUpdate
                    } else {
                        sellOrders.append(entryToUpdate)
                    }
                }
            }
        }
    }
}

extension OrderBookEntry: Equatable {
    
    static func == (lhs: OrderBookEntry, rhs: OrderBookEntry) -> Bool {
        return lhs.price == rhs.price
    }
}
