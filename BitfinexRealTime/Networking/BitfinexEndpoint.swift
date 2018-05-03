//
//  BitfinexEndpoint.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 03.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import Foundation

/// The BitfinexEndpoint protocol helps us formalize our API endpoints.
///
/// Some of the values of BitfinexEndpoint are default for each endpoint.
/// Other values needs to be defined in each class that conforms to this protocol.

typealias BitfinexEndpointRequestCompletionHandler = (Any?, Error?) -> ()


protocol BitfinexEndpoint {
    
    /// The bitfinex base url
    var endpointBaseURL: String { get }
    
    /// The path to the endpoint
    var endpointPath: String { get }
    
    /// The full url composed by baseUrl + path
    var endpointFullURL: String { get }
    
    /// The HTTP method used to perform a request to this endpoint
    var endpointHttpMethod: String { get }
}



extension BitfinexEndpoint {
    
    // Some default values
    var endpointBaseURL: String {
        return "https://api.bitfinex.com/v1"
    }
    var endpointFullURL: String {
        return endpointBaseURL + endpointPath
    }
}
