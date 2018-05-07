//
//  OrderBookTableViewCell.swift
//  BitfinexRealTime
//
//  Created by Ferdinando Messina on 07.05.18.
//  Copyright © 2018 Ferdinando Messina. All rights reserved.
//

import UIKit

class OrderBookTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    static func reuseIdentifier() -> String {
        return "OrderBookTableViewCellReuseIdentifier"
    }
    
    static func cellNib() -> UINib {
        return UINib(nibName: "OrderBookTableViewCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        self.priceLabel.text = ""
        self.amountLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(withOrderBookEntry entry: OrderBookEntry) {
        self.priceLabel.text = "\(entry.price)"
        if entry.isBuyOrder {
            self.amountLabel.text = "\(entry.amount)"
        } else {
            // Sells amount are negative, we use abs
            self.amountLabel.text = "\(abs(entry.amount))"
        }
    }
    
    func configureAsHeader() {
        self.priceLabel.text = "PRICE"
        self.amountLabel.text = "AMOUNT"
    }
}
