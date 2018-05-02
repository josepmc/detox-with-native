//
//  CurrencyPairTests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class CurrencyPairTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCurrencyPairInitializationWithEmptyIdentifier() {
        // Given
        let emptyIdentifier = ""
        // When
        let currencyPair = CurrencyPair(identifier: emptyIdentifier)
        // Then
        XCTAssertNil(currencyPair)
    }
    
    
    func testCurrencyPairInitializationWithTooShortIdentifier() {
        // Given
        let tooShortIdentifier = "btcus"
        // When
        let currencyPair = CurrencyPair(identifier: tooShortIdentifier)
        // Then
        XCTAssertNil(currencyPair)
    }
    
    func testCurrencyPairInitializationWithTooLongIdentifier() {
        // Given
        let tooLongIdentifier = "btcusda"
        // When
        let currencyPair = CurrencyPair(identifier: tooLongIdentifier)
        // Then
        XCTAssertNil(currencyPair)
    }

    func testCurrencyPairInitializationWithGoodIdentifier() {
        // Given
        let goodIdentifier = "btcusd"
        // When
        let currencyPair = CurrencyPair(identifier: goodIdentifier)
        // Then
        XCTAssertNotNil(currencyPair)
    }

    func testCurrencyPairHasProperReadableName() {
        // Given
        let btcUsdIdentifier = "btcusd"
        let readableName = "btc/usd"
        // When
        let currencyPair = CurrencyPair(identifier: btcUsdIdentifier)
        // Then
        if let notNilCurrencyPair = currencyPair {
            XCTAssertEqual(notNilCurrencyPair.readableName, readableName)
        } else {
            XCTFail()
        }
    }


}
