//
//  BitfinexSymbolsAPI.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation
import Alamofire

// API URL
// https://api.bitfinex.com/v1/symbols

class BitfinexSymbolsAPI: NSObject, BitfinexEndpoint {
    
    // Symbols Endpoint customization
    var endpointPath: String {
        return "/symbols/"
    }
    var endpointHttpMethod: String {
        return "GET"
    }
    
    /// Perform an API call to fetch the available symbols from Bitfinex
    ///
    /// - Parameters:
    ///   - completionHandler: A completion handler performed when the operation is completed
    ///
    func getSymbols(completionHandler completion: @escaping BitfinexEndpointRequestCompletionHandler) {
        
        var request = URLRequest(url: URL(string: endpointFullURL)!)
        request.httpMethod = endpointHttpMethod
        request.timeoutInterval = 10

        Alamofire.request(request).responseJSON { response in
            
            print("DEBUG: BitfinexSymbolsAPI:getSymbols, response \(response)")
            
            switch response.result {
                
            case .success(let json):
                completion(json, nil)
                
            case .failure(let error):
                print("DEBUG: BitfinexSymbolsAPI:getSymbols, an error occurred \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
}
