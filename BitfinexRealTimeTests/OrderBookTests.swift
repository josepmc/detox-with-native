//
//  OrderBookTests.swift
//  BitfinexRealTimeTests
//
//  Created by Ferdinando Messina on 07.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import XCTest

class OrderBookTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testItCreatesOrderBookWithTwoEntries() {
        // Given
        let buyOrder = OrderBookEntry(price: 1000, count: 1, amount: 23) // Buy Order amout positive
        let sellOrder = OrderBookEntry(price: 1100, count: 1, amount: -20) // Sell Order amout negative
        
        // When
        let newOrderBook = OrderBook(orderBookEntries: [buyOrder, sellOrder])
        
        // Then
        XCTAssertEqual(newOrderBook.buyOrders.count, 1)
        XCTAssertEqual(newOrderBook.sellOrders.count, 1)
    }
    
    func testItReturnsIndexOfEntry() {
        // Given
        let buyOrder = OrderBookEntry(price: 1000, count: 1, amount: 23) // Buy Order amount positive
        let buyOrder2 = OrderBookEntry(price: 1050, count: 1, amount: 12) // Buy Order amount positive
        let sellOrder = OrderBookEntry(price: 1100, count: 1, amount: -20) // Sell Order amount negative
        
        // When
        let newOrderBook = OrderBook(orderBookEntries: [buyOrder, buyOrder2, sellOrder])
        let buyOrderToFind = OrderBookEntry(price: 1050, count: 1, amount: 12) // Buy Order amount positive

        // Then
        XCTAssertEqual(newOrderBook.buyOrders.index(where: {$0 == buyOrderToFind}), 1)
    }

    
    /// -----------------------
    ///    UPDATES
    /// -----------------------
    
    func testItRemovesOrderFromBook() {
        // Given
        let buyOrder = OrderBookEntry(price: 1000, count: 1, amount: 23)
        let buyOrder2 = OrderBookEntry(price: 1050, count: 1, amount: 12)
        let sellOrder = OrderBookEntry(price: 1100, count: 1, amount: -20)
        
        // When
        let newOrderBook = OrderBook(orderBookEntries: [buyOrder, buyOrder2, sellOrder])
        let orderToRemove = OrderBookEntry(price: 1100, count: 0, amount: -1)
        newOrderBook.update(withEntries: [orderToRemove])
        
        // Then
        XCTAssertEqual(newOrderBook.sellOrders.index(where: {$0 == orderToRemove}), nil)
    }

    
    func testItUpdatesOrderBookWithNewAndExistingBuy() {
        // Given
        let buyOrder = OrderBookEntry(price: 1000, count: 1, amount: 23)
        let buyOrder2 = OrderBookEntry(price: 1050, count: 1, amount: 12)
        let sellOrder = OrderBookEntry(price: 1100, count: 1, amount: -20)
        
        // When
        let newOrderBook = OrderBook(orderBookEntries: [buyOrder, buyOrder2, sellOrder])
        let buyOrderToUpdate = OrderBookEntry(price: 1000, count: 3, amount: 55)
        let buyOrderToInsert = OrderBookEntry(price: 1020, count: 2, amount: 36)
        newOrderBook.update(withEntries: [buyOrderToUpdate, buyOrderToInsert])
        
        // Then
        XCTAssertEqual(newOrderBook.buyOrders.count, 3)
        if let indexOfUpdatedOrder = newOrderBook.buyOrders.index(where: {$0 == buyOrderToUpdate}) {
            let orderUpdated = newOrderBook.buyOrders[indexOfUpdatedOrder]
            XCTAssertEqual(orderUpdated.amount, 55)
            XCTAssertEqual(orderUpdated.count, 3)
        } else {
            XCTFail()
        }
        
        if let indexOfNewOrder = newOrderBook.buyOrders.index(where: {$0 == buyOrderToInsert}) {
            let newOrder = newOrderBook.buyOrders[indexOfNewOrder]
            XCTAssertEqual(newOrder.amount, 36)
            XCTAssertEqual(newOrder.count, 2)
        } else {
            XCTFail()
        }
    }

    /// -----------------------
    ///   SORTING
    /// -----------------------
    
    func testItReturnsSortedBuyOrdersFromHighToLow() {
        // Given
        let buyOrder1 = OrderBookEntry(price: 1000, count: 1, amount: 23)
        let buyOrder2 = OrderBookEntry(price: 1050, count: 1, amount: 12)
        let buyOrder3 = OrderBookEntry(price: 1100, count: 1, amount: 55)
        let buyOrder4 = OrderBookEntry(price: 1150, count: 1, amount: 20)
        
        // When
        let newOrderBook = OrderBook(orderBookEntries: [buyOrder1, buyOrder2, buyOrder3, buyOrder4])
        let sortedBuys = newOrderBook.sortedBuyOrders
        
        // Then
        XCTAssertEqual(sortedBuys.count, newOrderBook.buyOrders.count)
        XCTAssertEqual(sortedBuys[0].price, 1150)
        XCTAssertEqual(sortedBuys[1].price, 1100)
        XCTAssertEqual(sortedBuys[2].price, 1050)
        XCTAssertEqual(sortedBuys[3].price, 1000)
    }

    
    func testItReturnsSortedSellOrdersFromLowToHigh() {
        // Given
        let sellOrder1 = OrderBookEntry(price: 1000, count: 1, amount: -23)
        let sellOrder2 = OrderBookEntry(price: 1050, count: 1, amount: -12)
        let sellOrder3 = OrderBookEntry(price: 1100, count: 1, amount: -55)
        let sellOrder4 = OrderBookEntry(price: 1150, count: 1, amount: -20)
        
        // When
        let newOrderBook = OrderBook(orderBookEntries: [sellOrder1, sellOrder2, sellOrder3, sellOrder4])
        let sortedSells = newOrderBook.sortedSellOrders
        
        // Then
        XCTAssertEqual(sortedSells.count, newOrderBook.sellOrders.count)
        XCTAssertEqual(sortedSells[0].price, 1000)
        XCTAssertEqual(sortedSells[1].price, 1050)
        XCTAssertEqual(sortedSells[2].price, 1100)
        XCTAssertEqual(sortedSells[3].price, 1150)
    }
}
