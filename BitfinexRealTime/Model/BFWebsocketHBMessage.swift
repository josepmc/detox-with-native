//
//  BFWebsocketHBMessage.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 04.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation


/// If there is no activity in the channel for 5 second, the Websocket server will send
/// you an heartbeat message in this format.
///
/// Example
/// [ CHANNEL_ID, "hb" ]
///
struct BFWebsocketHBMessage: BFWebsocketMessage {
    
    var responseType: BitfinexWebsocketMessageType {
        return .channelHeartbeating
    }
    let channelId: Int

    init?(withJson jsonObject: ChannelMessage) {
        
        guard let chanId = jsonObject.first as? Int else {
            return nil
        }
        channelId = chanId
    }
}
