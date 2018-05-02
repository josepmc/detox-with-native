//
//  CurrencyPair.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

class CurrencyPair: NSObject {

    // pairIdentifier must be of 6 chars to create a CurrencyPair (this seems standard from Bitfinex)
    private static let IdentifierDefaultLength = 6
    
    let readableName: String
    let identifier: String
    
    // TODO: Would be nice to add an image icon on each currency pair, maybe in a future version
    
    /// Creates a currency pair object
    ///
    /// - Parameters:
    ///   - pairIdentifier: the currency pairidentifier
    ///
    /// - Returns: a CurrencyPair object or nil
    init?(identifier pairIdentifier: String) {
        
        guard pairIdentifier.count == CurrencyPair.IdentifierDefaultLength else {
            return nil
        }
        
        identifier = pairIdentifier
        readableName = pairIdentifier.separated(every: 3, withSeparator: " / ")
    }
}
