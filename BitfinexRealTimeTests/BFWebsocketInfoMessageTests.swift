//
//  BFWebsocketInfoMessageTests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 05.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class BFWebsocketInfoMessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitInfoMessageWithProperJson() {
        
        // Given
        let goodJsonString = "{ \"event\": \"info\", \"version\":  1, \"platform\": { \"status\": 1 } }"
        let jsonObjectOrNil = goodJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketInfoMessage = BFWebsocketInfoMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNotNil(websocketInfoMessage)
    }
    
    func testInitInfoMessageWithEmptyJson() {
       
        // Given
        let emptyJsonString = "{ }"
        let jsonObjectOrNil = emptyJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }

        // When
        let websocketInfoMessage = BFWebsocketInfoMessage(withJson: jsonObject)

        // Then
        XCTAssertNil(websocketInfoMessage)
    }

    
    func testInitInfoMessageWithWrongJson() {
        
        // Given
        let wrongJsonString = "{ \"blablabla\": \"1234\", \"MOON\":  1, \"platform\": { \"status\": 1 } }"
        let jsonObjectOrNil = wrongJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketInfoMessage = BFWebsocketInfoMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNil(websocketInfoMessage)
    }

}
