//
//  BitfinexSymbolsAPITests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class BitfinexSymbolsAPITests: XCTestCase {
    
    var apiUnderTest: BitfinexSymbolsAPI!
    
    override func setUp() {
        super.setUp()
        apiUnderTest = BitfinexSymbolsAPI()
    }
    
    override func tearDown() {
        apiUnderTest = nil
        super.tearDown()
    }
    
    func testCallToSymbolsApiCompletesWithResultWithoutError() {
        
        // Given
        let testExpectation = expectation(description: "completion handler invoked")
        var responseError: Error?
        var currencyPairs: [String]?

        // When
        apiUnderTest.getSymbols { (symbols, error) in
            responseError = error
            currencyPairs = symbols
            testExpectation.fulfill()
        }
        
        // waitForExpectations keeps the test running until all expectations are fulfilled or the timeout interval ends
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertNil(responseError)
        XCTAssertNotNil(currencyPairs)
    }
    
}
