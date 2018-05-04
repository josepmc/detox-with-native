//
//  StringExtensions.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

extension String {

    /// Separate a string with a custom separator every N characters
    ///
    /// - Parameters:
    ///   - stepAmount: the amount of characters we want to keep at each separation
    ///   - separator: the character we want to use to separate the string
    ///
    /// - Returns: A new separated string
    func separated(every stepAmount: Int, withSeparator separator: String) -> String {
        
        // if the step amount is not greater than zero we just return the same string, no separation will happen
        guard stepAmount > 0 else {
            return self
        }
        
        // stride(from:to:by:) returns a sequence from a starting value to, but not including, an end value, stepping by the specified amount.
        // with .map we loop over each element of the sequence and we create a collection that we want to separate
        // then we join each collection with the separator
        return String(stride(from: 0, to: Array(self).count, by: stepAmount).map {
                Array(Array(self)[$0..<min($0 + stepAmount, Array(self).count)])
            }.joined(separator: separator)
        )
    }
}


extension String {
    
    /// Parse the string to return a value of type Any
    ///
    /// - Returns: A value of type Any or nil
    func parseAsJSON() -> Any? {
        guard let stringData = self.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: stringData, options: [])
    }

}
