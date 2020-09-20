//
//  ProfileLastOrderCells.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 14.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class ProfileLastOrderCells: UITableViewCell {
    let model = DataModel.sharedData

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setView(number: Int){
        nameLabel.text = "\(model.lastOrder[number].name), \(model.lastOrder[number].brand)"
        nameLabel.sizeToFit()
        countLabel.text = "\(model.lastOrder[number].count)"
    }
    
}
