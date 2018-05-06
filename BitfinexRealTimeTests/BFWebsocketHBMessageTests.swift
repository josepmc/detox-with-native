//
//  BFWebsocketHBMessageTests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 05.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class BFWebsocketHBMessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitHBMessageWithProperJson() {
        
        // Given
        let goodJsonString = "[232, \"hb\"]"
        let jsonObjectOrNil = goodJsonString.parseAsJSON() as? ChannelMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketHBMessage = BFWebsocketHBMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNotNil(websocketHBMessage)
        XCTAssertEqual(232, websocketHBMessage?.channelId)
    }
    
    func testInitHBMessageWithEmptyJson() {
        
        // Given
        let emptyJsonString = "[]"
        let jsonObjectOrNil = emptyJsonString.parseAsJSON() as? ChannelMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketHBMessage = BFWebsocketHBMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNil(websocketHBMessage)
    }
    
    
    func testInitHBMessageWithWrongJson() {
        
        // Given
        let wrongJsonString = "[\"spaghetti\", 1234]"
        let jsonObjectOrNil = wrongJsonString.parseAsJSON() as? ChannelMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketHBMessage = BFWebsocketHBMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNil(websocketHBMessage)
    }
}
