//
//  BFWebsocketTickerUpdateMessage.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 06.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation


/// The ticker is an high level overview of the state of the market.
/// It shows you the current best bid and ask, as well as the last trade price.
/// It also includes information such as daily volume and how much the price has moved over the last day.
///
/// Example Message:
/// [
///   CHANNEL_ID,
///   [ BID, BID_SIZE, ASK, ASK_SIZE, DAILY_CHANGE, DAILY_CHANGE_PERC, LAST_PRICE, VOLUME, HIGH, LOW ]
/// ]
///
struct BFWebsocketTickerUpdateMessage: BFWebsocketMessage {
    
    /// The indexes used to access the values we need in the received array
    private let DailyChangePercentageValueIndex = 5
    private let LastPriceValueIndex = 6
    private let VolumeValueIndex = 7
    private let DailyHighValueIndex = 8
    private let DailyLowValueIndex = 9

    var responseType: BitfinexWebsocketMessageType {
        return .channelUpdate
    }
    let channelId: Int
    
    // Among all the info returned by this message, we store only some of them
    let dailyChangePercentage: Float
    let lastPrice: Float
    let volume: Float
    let dailyHigh: Float
    let dailyLow: Float
    
    init?(withJson jsonObject: ChannelMessage) {
        
        // Intergrity checks on the received json
        guard jsonObject.count > 1 else {
            // If the array does not have a second element we return
            return nil
        }
        guard let tickerUpdates = jsonObject[1] as? [NSNumber] else {
            // If the array does not have a tickerUpdates made of NSNumber we return
            // !! Why NSNumber (typical obj-c type) and not a native Float?
            // Because for arrays or dictionaries coming as a resut of JSONSerialization
            //  the number inside is always an NSNumber
            //  (see https://stackoverflow.com/a/49703477/598200)
            return nil
        }
        
        // We can now access and store all our properties
        guard let chanId = jsonObject.first as? Int else {
            return nil
        }
        channelId = chanId
        dailyChangePercentage = tickerUpdates[DailyChangePercentageValueIndex].floatValue
        lastPrice = tickerUpdates[LastPriceValueIndex].floatValue
        volume = tickerUpdates[VolumeValueIndex].floatValue
        dailyHigh = tickerUpdates[DailyHighValueIndex].floatValue
        dailyLow = tickerUpdates[DailyLowValueIndex].floatValue
    }
}

