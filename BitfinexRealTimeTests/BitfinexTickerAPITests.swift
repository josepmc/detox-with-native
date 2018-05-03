//
//  BitfinexTickerAPITests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 03.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class BitfinexTickerAPITests: XCTestCase {
    
    var apiUnderTest: BitfinexTickerAPI!
    
    override func setUp() {
        super.setUp()
        apiUnderTest = BitfinexTickerAPI()
    }
    
    override func tearDown() {
        apiUnderTest = nil
        super.tearDown()
    }

    func testCallToSymbolInfoApiCompletesWithResultWithoutError() {
        
        // Given
        let testExpectation = expectation(description: "completion handler invoked")
        var responseError: Error?
        var symbolInfoResult: [String: String]?
        
        let symbolIdentifier = "btcusd"
        
        // When
        apiUnderTest.getSymbolInfo(symbolIdentifier) { (json, error) in
            responseError = error
            symbolInfoResult = json as? [String: String]
            testExpectation.fulfill()
        }
        
        // waitForExpectations keeps the test running until all expectations are fulfilled or the timeout interval ends
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertNil(responseError)
        XCTAssertNotNil(symbolInfoResult)
    }
    
    
    func testWrongCallToSymbolInfoApiCompletesWithError() {
        
        // Expected Result of this api call is
        // SUCCESS: { message = "Unknown symbol";}

        
        // Given
        let testExpectation = expectation(description: "completion handler invoked")
        var responseError: Error?
        var symbolInfoResult: [String: String]?
        
        let wrongSymbolIdentifier = "btcusd*"
        let messageKey = "message"
        let expectedResult = [messageKey: "Unknown symbol"]
        
        // When
        apiUnderTest.getSymbolInfo(wrongSymbolIdentifier) { (json, error) in
            responseError = error
            symbolInfoResult = json as? [String: String]
            testExpectation.fulfill()
        }
        
        // waitForExpectations keeps the test running until all expectations are fulfilled or the timeout interval ends
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertNil(responseError)
        XCTAssertNotNil(symbolInfoResult)

        if let notNilSymbolInfoResult = symbolInfoResult {
            XCTAssertEqual(notNilSymbolInfoResult[messageKey], expectedResult[messageKey])
        }
    }

}
