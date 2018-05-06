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
            
            for element in jsonChannelMessage {
                if let elementString = element as? String, elementString == "hb" {
                    // Hearthbeat message
                    return BFWebsocketHBMessage(withJson: jsonChannelMessage)
                }
                
                
            }

        }
        
        return nil
    }
}
