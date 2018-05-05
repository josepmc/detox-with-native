//
//  StringExtensionsTests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class StringExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    /// ------------------------------
    /// separated(every: withSeparator:) extension tests
    /// ------------------------------

    //MARK:- String Separation Tests
    
    func testSeparateStringEveryZeroCharacters() {
        
        // Given
        let exampleString = "justastring"
        let zeroCharsStep = 0
        
        // When
        let exampleStringZeroSeparated = exampleString.separated(every: zeroCharsStep, withSeparator: "$")
        
        // Then
        XCTAssertEqual(exampleString, exampleStringZeroSeparated)
    }
    
    
    func testSeparateStringWithEmptySeparator() {
        
        // Given
        let exampleString = "justanotherstring"
        let emptySeparator = ""
        
        // When
        let exampleStringSeparated = exampleString.separated(every: 2, withSeparator: emptySeparator)
        
        // Then
        XCTAssertEqual(exampleString, exampleStringSeparated)
    }
    
    
    func testSeparateStringWithEmojiCharacter() {
        
        // Given
        let pizzaString = "pizzapizzapizza"
        let emojiSeparator = "🍕"
        let handmadeSeparatedString = "pizza🍕pizza🍕pizza"
        
        // When
        let pizzaSeparatedPizzaString = pizzaString.separated(every: "pizza".count, withSeparator: emojiSeparator)
        
        // Then
        XCTAssertEqual(handmadeSeparatedString, pizzaSeparatedPizzaString)
    }
    
   
    func testSeparateStringWithDoubleCharSeparator() {

        // Given
        let exampleString = "exampleString"
        let doubleCharSeparator = "-*"
        let handmadeSeparatedString = "ex-*am-*pl-*eS-*tr-*in-*g"

        // When
        let exampleStringSeparated = exampleString.separated(every: 2, withSeparator: doubleCharSeparator)
        
        // Then
        XCTAssertEqual(handmadeSeparatedString, exampleStringSeparated)
    }
    
  
    func testSeparateStringNotSeparable() {
      
        // Given
        let emptyString = ""
        let oneCharString = "1"
        
        // When
        let emptyStringSeparated = emptyString.separated(every: 2, withSeparator: "-")
        let oneCharStringSeparated = oneCharString.separated(every: 3, withSeparator: "*")
        
        // Then
        XCTAssertEqual(emptyString, emptyStringSeparated)
        XCTAssertEqual(oneCharString, oneCharStringSeparated)
    }
    
    
    /// ------------------------------
    /// parseAsJSON() extension tests
    /// ------------------------------
    
    //MARK:- Parse string as Json tests
    
    func testParseAsJsonEmptyString() {
        
        // Given
        let emptyString = ""
        
        // When
        let jsonObject = emptyString.parseAsJSON()
        
        // Then
        XCTAssertNil(jsonObject)
    }
    
    
    func testParseAsJsonNonJsonString() {
        
        // Given
        let nonJsonString = "abcdefcga"
        
        // When
        let jsonObject = nonJsonString.parseAsJSON()
        
        // Then
        XCTAssertNil(jsonObject)
    }
    
    
    func testParseAsJsonValidJsonString() {
        
        // Given
        let validJsonString = "{ \"event\": \"info\", \"version\":  \"1\", \"platform\": \"test\"}"
        
        // When
        let jsonObject = validJsonString.parseAsJSON() as? [String: String]
        
        // Then
        XCTAssertNotNil(jsonObject)
        if let jsonParsed = jsonObject {
            XCTAssertEqual(jsonParsed["event"], "info")
            XCTAssertEqual(jsonParsed["version"], "1")
        }
        
    }


}
