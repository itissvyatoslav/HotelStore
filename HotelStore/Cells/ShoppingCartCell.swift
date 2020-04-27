//
//  ShoppingCartCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 16.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell {
    let cart = DataModel.sharedData
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var countProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBAction func minusCount(_ sender: Any) {
        
    }
    @IBAction func plusCount(_ sender: Any) {
        
    }
    @IBAction func deleteProduct(_ sender: Any) {
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ number: Int){
        
        
    }
    
}
