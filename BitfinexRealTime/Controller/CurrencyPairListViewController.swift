//
//  ViewController.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

class CurrencyPairListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var currencyPairs: [CurrencyPair]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Currency Pairs"
        currencyPairs = [CurrencyPair]()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        BitfinexSymbolsAPI().getSymbols { (symbols, _) in
            if let allCurrencyPairsIdentifier = symbols {
                for identifier in allCurrencyPairsIdentifier {
                    if let currencyPair = CurrencyPair(identifier: identifier) {
                        self.currencyPairs?.append(currencyPair)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CurrencyPairListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyPairs!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "CurrencyPairCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)

        cell.textLabel?.text = currencyPairs![indexPath.row].readableName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

