//
//  CurrencyPairViewController.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 03.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

class CurrencyPairViewController: UIViewController {

    var currencyPair: CurrencyPair!
    
    static func storyboardSegueIdentifier() -> String {
        return "currencyPairSelectedSegue"
    }
    
    func inject(currencyPair aCurrencyPair: CurrencyPair) {
        currencyPair = aCurrencyPair
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = currencyPair.readableName
        
        BitfinexTickerAPI().getSymbolInfo(currencyPair.identifier) { [unowned self] (json, error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
