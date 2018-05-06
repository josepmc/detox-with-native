//
//  BitfinexWSResponseConstructor.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 04.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

class BitfinexWSResponseConstructor: NSObject {
    
    /// This method will parse a websocket string response and return the proper response object
    ///
    /// - Parameters:
    ///   - jsonString: The response string received on the web socket
    ///
    static func websocketMessage(fromJsonString jsonString: String) -> BFWebsocketMessage? {
        
        guard let jsonObject = jsonString.parseAsJSON() else {
            return nil
        }
        
        // EVENT Message
        if let jsonEventMessage = jsonObject as? EventMessage {
            if let jsonEvent = jsonEventMessage["event"] as? String {
                switch jsonEvent {
                
                case "info":
                    // Return Info Message
                    return BFWebsocketInfoMessage(withJson: jsonEventMessage)
                
                case "pong":
                    // Pong Message (not treated)
                    print("Debug: Pong Message received, we don't treat it for the moment")
                
                case "subscribed":
                    if let channelName = jsonEventMessage["channel"] as? String {
                        // Return Ticker Channel Subscription Message
                        if channelName == BFWebsocketTickerSubscriptionMessage.channelName {
                            return BFWebsocketTickerSubscriptionMessage(withJson: jsonEventMessage)
                        }
                    }
                    
                case "unsubscribed":
                    // Return Unsubscribe Event
                    print("UNSUBSCRIBE EVENT")
                
                case "error":
                    // Return Error Event
                    return BFWebsocketErrorMessage(withJson: jsonEventMessage)
                
                default:
                    return nil
                }
            }
        }
        
        // Channel Message
        if let jsonChannelMessage = jsonObject as? ChannelMessage {
            
            guard jsonChannelMessage.count > 1 else {
                // We expect an update message array to have at least 2 elements
                return nil
            }
            
            if let _ = jsonChannelMessage[0] as? Int {
                // We have a channelId, we check for different types of update
                
                // HB update
                if let secondElement = jsonChannelMessage[1] as? String, secondElement == "hb" {
                    // Hearthbeat message
                    return BFWebsocketHBMessage(withJson: jsonChannelMessage)
                }
                
                // Ticker Update
                if let _ = jsonChannelMessage[1] as? [Any] {
                    return BFWebsocketTickerUpdateMessage(withJson: jsonChannelMessage)
                }
                
            }

        }
        
        return nil
    }
}
