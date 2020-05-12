//
//  ShoppingCartCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell {
    let model = DataModel.sharedData
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBAction func minusButton(_ sender: Any) {
    }
    @IBAction func plusButton(_ sender: Any) {
    }
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBAction func deleteAction(_ sender: Any) {
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
        title.text = model.shopCart[number].name
        countLabel.text = "\(model.shopCart[number].count)"
        priceLabel.text = "\(model.shopCart[number].price)S$"
        setImage(number)
    }
    
    private func setImage(_ number: Int){
        let semaphore = DispatchSemaphore (value: 0)
        if let url = URL(string: "http://176.119.157.195:8080/\(model.shopCart[number].images[0].url)"){
            do {
                let data = try Data(contentsOf: url)
                self.imageProduct.image = UIImage(data: data)
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
}
