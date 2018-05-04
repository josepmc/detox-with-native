//
//  CurrencyPairViewController.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 03.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit
import Starscream

class CurrencyPairViewController: UIViewController {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var socketStatus: UILabel!
    
    var currencyPair: CurrencyPair!
    var bitfinexSocket = WebSocket(url: URL(string: "wss://api.bitfinex.com/ws/2")!)
    
    static func storyboardSegueIdentifier() -> String {
        return "currencyPairSelectedSegue"
    }
    
    func inject(currencyPair aCurrencyPair: CurrencyPair) {
        currencyPair = aCurrencyPair
    }
    
    deinit {
        // We make sure we close the socket when we deinitialize the view controller
        bitfinexSocket.disconnect()
        bitfinexSocket.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = currencyPair.readableName
        
        // Connect the socket
        bitfinexSocket.delegate = self
        bitfinexSocket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK:- WebSocketvDelegate

extension CurrencyPairViewController: WebSocketDelegate {

    func websocketDidConnect(socket: WebSocketClient) {
        print("bitfinexWebSocket \(socket) is now connected")
        updateSocketConnectionStatus(isConnected: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            socket.disconnect()
        }
//        let tickerRequest = ["event": "subscribe", "channel": "ticker", "symbol": currencyPair.identifier]
//        if let jsonData = try? JSONSerialization.data(withJSONObject: tickerRequest, options: .prettyPrinted) {
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                socket.write(string: jsonString)
//            }
//        }
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("bitfinexWebSocket is now disconnected: \(String(describing: error?.localizedDescription))")
        updateSocketConnectionStatus(isConnected: false)

    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("bitfinexWebSocket got some text: \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("bitfinexWebSocket got some data: \(data.count)")
    }
}


// MARK:- UI updates

extension CurrencyPairViewController {
    
    private func updateSocketConnectionStatus(isConnected connected: Bool) {
        socketStatus.text = connected ? "Connected" : "Disconnected"
        socketStatus.textColor = connected ? UIColor(red: 137.0/255, green: 196.0/255, blue: 79.0/255, alpha: 1) : UIColor.red
    }
}











