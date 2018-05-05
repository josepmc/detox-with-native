//
//  BFWebsocketErrorMessage.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 04.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation


/// In case of error, you receive a message containing the proper error code (code JSON field).
///
/// An example:
/// { "channel":"ticker",
///   "symbol":"asdasd",
///   "event":"error",
///   "msg":"symbol: invalid",
///   "code":10300,
///   "pair":"sdasd" }
///
struct BFWebsocketErrorMessage: BFWebsocketMessage {
    
    var responseType: BitfinexWebsocketMessageType {
        return .error
    }
    let errorCode: Int
    let errorMessage: String?
    
    init?(withJson jsonObject: EventMessage) {
        
        guard let code = jsonObject["code"] as? Int else {
            return nil
        }
        let message = jsonObject["msg"] as? String
        errorCode = code
        errorMessage = message
    }
}
