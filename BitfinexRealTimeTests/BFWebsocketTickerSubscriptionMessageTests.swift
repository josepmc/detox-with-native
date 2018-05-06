//
//  BFWebsocketChannelSubscriptionMessage.tests
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 06.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class BFWebsocketChannelSubscriptionMessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitTickerSubscriptionMessageWithProperJson() {
        
        // Given
        let goodJsonString = "{ \"event\":\"subscribed\", \"channel\":\"ticker\", \"chanId\":12345, \"pair\":\"BTCUSD\" }"
        
        let jsonObjectOrNil = goodJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketSubscriptionMessage = BFWebsocketChannelSubscriptionMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNotNil(websocketSubscriptionMessage)
        XCTAssertEqual(12345, websocketSubscriptionMessage?.channelId)
        XCTAssertEqual("BTCUSD", websocketSubscriptionMessage?.symbol)
    }
    
    func testInitTickerSubscriptionMessageWithEmpty() {
        
        // Given
        let emptyJsonString = "{ }"
        let jsonObjectOrNil = emptyJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketSubscriptionMessage = BFWebsocketChannelSubscriptionMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNil(websocketSubscriptionMessage)
    }
    
    
    func testInitTickerSubscriptionMessageWithWrongJson() {
        
        // Given
        let wrongJsonString = "{ \"event\":\"pumpdump\", \"channel\":\"ticker\", \"nochannel\":12345, \"pair\":\"BTCUSD\" }"
        let jsonObjectOrNil = wrongJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketSubscriptionMessage = BFWebsocketChannelSubscriptionMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNil(websocketSubscriptionMessage)
    }
}
