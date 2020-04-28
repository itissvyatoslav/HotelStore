//
//  ProductMiniCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 27.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class ProductMiniCell: UITableViewCell {
    let model = DataModel.sharedData
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var outLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setView(_ number: Int){
        nameLabel.text = model.products[number].name
        descrLabel.text = model.products[number].short_description
        costLabel.text = "\(model.products[number].price) S$"
        nameLabel.sizeToFit()
        descrLabel.sizeToFit()
        costLabel.sizeToFit()
    }
    
}
