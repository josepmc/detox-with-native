//
//  ViewController.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 02.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        BitfinexSymbolsAPI().getSymbols { (symbols, _) in
            if let allCurrencyPairs = symbols {
                print("currency pairs \(allCurrencyPairs)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

