//
//  ProductTableViewCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 28.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    let model = DataModel.sharedData
    
    var count = 1

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBAction func minusAction(_ sender: Any) {
        count = count - 1
        if count < 1 {
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        } else {
            numberLabel.text = "\(count)"
            numberLabel.sizeToFit()
        }
    }
    @IBAction func plusAction(_ sender: Any) {
        count = count + 1
        numberLabel.text = "\(count)"
        numberLabel.sizeToFit()
    }
    @IBAction func addAction(_ sender: Any) {
        count = 1
        addButton.isHidden = true
        numberLabel.isHidden = false
        numberLabel.text = "\(count)"
        minusButton.isHidden = false
        plusButton.isHidden = false
        numberLabel.sizeToFit()
    }
    
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
        priceLabel.text = "\(model.products[number].price)S$"
        nameLabel.sizeToFit()
        descrLabel.sizeToFit()
        priceLabel.sizeToFit()
        if model.products[number].count == 0 {
            countLabel.textColor = UIColor(red: 182/255, green: 9/255, blue: 73/255, alpha: 1)
            countLabel.text = "Out of stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = true
        } else {
            countLabel.textColor = UIColor(red: 21/255, green: 22/255, blue: 22/255, alpha: 0.5)
            countLabel.text = "\(model.products[number].count) in stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        }
        getImage(number)
    }
    
    private func getImage(_ number: Int){
        var subNumber = 0
        for imageNumber in 0..<model.products[number].images.count{
            if model.products[number].images[imageNumber].front {
                
                subNumber = imageNumber
                break
            }
        }
        //let semaphore = DispatchSemaphore (value: 0)
        if let url = URL(string: "http://176.119.157.195:8080/\(model.products[number].images[subNumber].url)"){
            do {
                let data = try Data(contentsOf: url)
                self.imageProduct.image = UIImage(data: data)
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
            //semaphore.signal()
        }
        //semaphore.wait()
    }
}
