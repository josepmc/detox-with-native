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
    
    private lazy var activityIndicatorBarButtonItem: UIBarButtonItem = {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return UIBarButtonItem(customView: activityIndicator)
    }()

    private lazy var refreshDataBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchData))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Currency Pairs"
        currencyPairs = [CurrencyPair]()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Download the data for the first time
        fetchData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == CurrencyPairViewController.storyboardSegueIdentifier() {
            let currencyPairVC = segue.destination as? CurrencyPairViewController
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // We inject to the currencyPair view controller the selected CurrencyPair object dependency
                currencyPairVC?.inject(currencyPair: currencyPairs![selectedIndexPath.row])
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CurrencyPairListViewController {
    
    private func showLoadingDataUI() {
        navigationItem.rightBarButtonItem = activityIndicatorBarButtonItem
    }
    
    private func showDataReadyUI() {
        navigationItem.rightBarButtonItem = refreshDataBarButtonItem
    }
    
    @objc private func fetchData() {
        
        // Download the symbols from bitfinex
        // Fill our array of CurrencyPair
        // Reload the tableView to display the list of currency pairs
        
        showLoadingDataUI()
        
        BitfinexSymbolsAPI().getSymbols { [unowned self] (json, error) in
            
            if let requestError = error {
                // An error occurred during the request
                // Present an alert and return
                self.showApiRequestError(requestError.localizedDescription)
                self.showDataReadyUI()
                return
            }
            
            if let apiResultDictionary = json as? [String: String], let apiResultError = apiResultDictionary["error"] {
                // The request failed due to an api error
                // Present an alert and return
                self.showApiRequestError(apiResultError)
                self.showDataReadyUI()
                return
            }
            
            if let allCurrencyPairsIdentifier = json as? [String] {
                // The request returned an array of strings, we save them as our currency pairs
                DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                    self.fillCurrencyPairs(forIdentifiers: allCurrencyPairsIdentifier)
                    
                    DispatchQueue.main.async { [unowned self] in
                        self.showDataReadyUI()
                        self.tableView.reloadData()
                    }
                }
            } else {
                // Unkown error
                // Api unkown response
                self.showApiRequestError("An unknown error occurred. Please retry.")
                self.showDataReadyUI()
            }
        }
    }
    
    private func fillCurrencyPairs(forIdentifiers identifiers: [String]) {
        for identifier in identifiers {
            if let currencyPair = CurrencyPair(identifier: identifier) {
                self.currencyPairs?.append(currencyPair)
            }
        }
    }
    
    private func showApiRequestError(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
        self.performSegue(withIdentifier: CurrencyPairViewController.storyboardSegueIdentifier(), sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

