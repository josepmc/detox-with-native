//
//  BFWebsocketErrorMessageTests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 06.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class BFWebsocketErrorMessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testInitErrorMessageWithProperJson() {
        
        // Given
        let goodJsonString = "{ \"channel\":\"ticker\", \"symbol\":\"asdasd\", \"event\":\"error\", \"msg\":\"symbol: invalid\", \"code\":10300, \"pair\":\"wrongpari\" }"

        let jsonObjectOrNil = goodJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketErrorMessage = BFWebsocketErrorMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNotNil(websocketErrorMessage)
        XCTAssertEqual(10300, websocketErrorMessage?.errorCode)
        XCTAssertEqual("symbol: invalid", websocketErrorMessage?.errorMessage)
    }
    
    func testInitErrorMessageWithEmptyJson() {
        
        // Given
        let emptyJsonString = "{ }"
        let jsonObjectOrNil = emptyJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketErrorMessage = BFWebsocketErrorMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNil(websocketErrorMessage)
    }
    
    
    func testInitErrorMessageWithWrongJson() {
        
        // Given
        let wrongJsonString = "{ \"test\":\"asdasd\", \"symbol\":\"asdasd\", \"test2\":\"qwerty\", \"msg\":\"symbol: invalid\", \"nocode\":12345 }"
        let jsonObjectOrNil = wrongJsonString.parseAsJSON() as? EventMessage
        
        guard let jsonObject = jsonObjectOrNil else {
            XCTFail("Wrong testing json provided")
            return
        }
        
        // When
        let websocketErrorMessage = BFWebsocketErrorMessage(withJson: jsonObject)
        
        // Then
        XCTAssertNil(websocketErrorMessage)
    }

}
