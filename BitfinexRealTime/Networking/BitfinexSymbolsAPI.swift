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
    
    typealias GetSymbolsCompletionHandler = ([String]?, Error?) -> ()
    
    let session: URLSession!
    let apiUrlString: String
    
    override init() {
        session = URLSession(configuration: .default)
        apiUrlString = "https://api.bitfinex.com/v1/symbols"
    }
    
    /// Perform an API call to fetch the available symbols from Bitfinex
    ///
    /// - Parameters:
    ///   - completionHandler: a completion handler performed when the operation is completed
    ///
    func getSymbols(completionHandler completion: @escaping GetSymbolsCompletionHandler) {
        
        Alamofire.request(apiUrlString).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let jsonResult = json as? [String] {
                    completion(jsonResult, nil)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
}
