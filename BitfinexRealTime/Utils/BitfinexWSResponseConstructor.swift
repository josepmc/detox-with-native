//
//  BitfinexWSResponseConstructor.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 04.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

class BitfinexWSResponseConstructor: NSObject {
    
    /// This method will parse a websocket event string response and return the proper response object
    ///
    /// - Parameters:
    ///   - jsonString: The response string received on the web socket
    ///
    static func websocketEventMessage(fromJsonEventMessage jsonEventMessage: EventMessage) -> BFWebsocketMessage? {
                
        if let jsonEvent = jsonEventMessage["event"] as? String {
            switch jsonEvent {
            
            case "info":
                // Return Info Message
                return BFWebsocketInfoMessage(withJson: jsonEventMessage)
            
            case "pong":
                // Pong Message (not treated)
                print("Debug: Pong message received, we don't treat it for the moment")
            
            case "subscribed":
                if let channelName = jsonEventMessage["channel"] as? String {
                    // Return Ticker Channel Subscription Message
                    if channelName == BitfinexWSTickerChannel.channelName {
                        return BFWebsocketTickerSubscriptionMessage(withJson: jsonEventMessage)
                    }
                }
                
            case "unsubscribed":
                // Unsubscribed event (not treated)
                print("Debug: Unsubscribed message received, we don't treat it for the moment")

            case "error":
                // Return Error Event
                return BFWebsocketErrorMessage(withJson: jsonEventMessage)
            
            default:
                return nil
            }
        }
        
        return nil
    }
    
    
    /// This method will parse a websocket channel update string response and return
    /// the proper channel update object
    ///
    /// - Parameters:
    ///   - jsonString: The response string received on the web socket
    ///   - channelName: The name of the channel where we received the update message
    ///
    static func websocketChannelUpdateMessage(fromJsonChannelMessage channelMessage: ChannelMessage, channelName: String) -> BFWebsocketMessage? {
        
        // Integrity checks first
        guard channelMessage.count > 1 else {
            // We expect an update message array to have at least 2 elements
            return nil
        }
        
        // Hearthbeat update message ?
        if let secondElement = channelMessage[1] as? String, secondElement == "hb" {
            return BFWebsocketHBMessage(withJson: channelMessage)
        }

        switch channelName {
        
        case BitfinexWSTickerChannel.channelName:
            // Ticker Update
            return BFWebsocketTickerUpdateMessage(withJson: channelMessage)
        
        case BitfinexWSOrderBookChannel.channelName:
            // Order Update
            return nil
        
        default:
            return nil
        }
    }
}
