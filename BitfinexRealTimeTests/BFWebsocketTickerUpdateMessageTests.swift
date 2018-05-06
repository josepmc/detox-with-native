//
//  BFWebsocketTickerUpdateMessageTests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 06.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class BFWebsocketTickerUpdateMessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitTickerUpdateMessageWithProperJson() {
        
        // Given
        let goodJsonString = "[1234, [169, 888.121, 169.05, 1769.8005, -10.23, -0.0571, 169.01, 234941.435, 184.7, 165.33] ]"
        let jsonObjectOrNil = goodJsonString.parseAsJSON() as? ChannelMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let tickerUpdateMessage = BFWebsocketTickerUpdateMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNotNil(tickerUpdateMessage)
        XCTAssertEqual(1234, tickerUpdateMessage?.channelId)
        XCTAssertEqual(-0.0571, tickerUpdateMessage?.dailyChangePercentage)
        XCTAssertEqual(169.01, tickerUpdateMessage?.lastPrice)
        XCTAssertEqual(234941.435, tickerUpdateMessage?.volume)
        XCTAssertEqual(184.7, tickerUpdateMessage?.dailyHigh)
        XCTAssertEqual(165.33, tickerUpdateMessage?.dailyLow)
    }
    
    func testInitTickerUpdateMessageWithEmptyJson() {
        
        // Given
        let emptyJsonString = "[]"
        let jsonObjectOrNil = emptyJsonString.parseAsJSON() as? ChannelMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let tickerUpdateMessage = BFWebsocketTickerUpdateMessage(withJson: jsonObject)

        // Then
        XCTAssertNil(tickerUpdateMessage)
    }
    
    
    func testInitTickerUpdateMessageWithWrongJson() {
        
        // Given
        let wrongJsonString = "[1234, \"hb\"]"
        let jsonObjectOrNil = wrongJsonString.parseAsJSON() as? ChannelMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let tickerUpdateMessage = BFWebsocketTickerUpdateMessage(withJson: jsonObject)

        // Then
        XCTAssertNil(tickerUpdateMessage)
    }
}
