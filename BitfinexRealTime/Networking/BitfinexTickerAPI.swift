//
//  BitfinexTickerAPI.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 03.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation
import Alamofire

// API URL
// https://api.bitfinex.com/v1/pubticker/{symbol}

class BitfinexTickerAPI: NSObject, BitfinexEndpoint {

    // Ticker Endpoint customization
    var endpointPath: String {
        return "/pubticker"
    }
    var endpointHttpMethod: String {
        return "GET"
    }
    
    /// Perform an API call to fetch the info about a particular symbol
    ///
    /// - Parameters:
    ///   - symbolId: The symbol you want information about
    ///   - completionHandler: A completion handler performed when the operation is completed
    ///
    func getSymbolInfo(_ symbolId: String, completionHandler completion: @escaping BitfinexEndpointRequestCompletionHandler) {
        
        let endpointFullURLWithPathParameters = "\(endpointFullURL)/\(symbolId)"
        var request = URLRequest(url: URL(string: endpointFullURLWithPathParameters)!)
        request.httpMethod = endpointHttpMethod
        request.timeoutInterval = 10
        
        Alamofire.request(request).responseJSON { response in
            
            print("DEBUG: BitfinexTickerAPI:getSymbolInfo/\(symbolId), response \(response)")
            
            switch response.result {
                
            case .success(let json):
                completion(json, nil)
                
            case .failure(let error):
                print("DEBUG: BitfinexTickerAPI:getSymbolInfo/\(symbolId), an error occurred \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        
    }

}
