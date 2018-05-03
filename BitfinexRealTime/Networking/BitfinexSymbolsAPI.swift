//
//  BitfinexSymbolsAPI.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation
import Alamofire

class BitfinexSymbolsAPI: NSObject {
    
    typealias GetSymbolsCompletionHandler = (Any?, Error?) -> ()
    
    let session: URLSession!
    let apiUrl: URL!
    
    override init() {
        session = URLSession(configuration: .default)
        apiUrl = URL(string: "https://api.bitfinex.com/v1/symbols")
    }
    
    /// Perform an API call to fetch the available symbols from Bitfinex
    ///
    /// - Parameters:
    ///   - completionHandler: a completion handler performed when the operation is completed
    ///
    func getSymbols(completionHandler completion: @escaping GetSymbolsCompletionHandler) {
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
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
