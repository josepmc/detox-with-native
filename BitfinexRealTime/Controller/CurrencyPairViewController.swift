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

    @IBOutlet weak var socketStatus: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var percentage24HoursLabel: UILabel!
    
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

        title = currencyPair.readableName
        view.backgroundColor = UIColor(red: 236.0/255, green: 240.0/255, blue: 241.0/255, alpha: 1)
        
        symbolLabel.text = currencyPair.identifier.uppercased()
        
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
        print("BitfinexWebSocket is now connected")
        
        // Update the UI
        updateSocketConnectionStatus(isConnected: true)
        
        // Subscribe to the WS Ticker channel
        let tickerChannel = BitfinexWSTickerChannel()
        if let tickerSubscriptionMessage = tickerChannel.tickerSubscriptionMessage(forSymbol: currencyPair.identifier) {
            socket.write(string: tickerSubscriptionMessage)
        }
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("BitfinexWebSocket is now disconnected: \(String(describing: error?.localizedDescription))")
        
        // Update the UI
        updateSocketConnectionStatus(isConnected: false)
        
        // Alert the user
        var errorMessage = "Socket Disconnected"
        if let anError = error {
            errorMessage = errorMessage + ": \(anError.localizedDescription)"
        }
        let disconnectedAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        disconnectedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(disconnectedAlert, animated: true, completion: nil)
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("BitfinexWebSocket received some text: \(text)")
        
        let message = BitfinexWSResponseConstructor.websocketMessage(fromJsonString: text)
        
        // -------------
        // INFO MESSAGE
        // -------------
        if message is BitfinexWebsocketInfoMessage {
            // we verify the status of the platform
            let infoMessage = message as! BitfinexWebsocketInfoMessage
            if !infoMessage.platformIsOperative {
                // If the platform is not operative, we disconnect
                socket.disconnect()
            }
        }
        
        // -------------
        // HEARTHBEAT MESSAGE
        // -------------
        if message is BitfinexWebsocketHBMessage {
            // nothing to do
            let hearthbeatMessage = message as! BitfinexWebsocketHBMessage
            print("Heartbeat message for channel \(hearthbeatMessage.channelId)")
        }
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("BitfinexWebSocket received some data: \(data.count)")
    }
}


// MARK:- UI updates

extension CurrencyPairViewController {
    
    private func updateSocketConnectionStatus(isConnected connected: Bool) {
        socketStatus.text = connected ? "Connected" : "Disconnected"
        socketStatus.textColor = connected ? UIColor(red: 137.0/255, green: 196.0/255, blue: 79.0/255, alpha: 1) : UIColor.red
    }
}











