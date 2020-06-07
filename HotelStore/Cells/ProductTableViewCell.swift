//
//  ProductTableViewCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 28.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

protocol ProductTableViewCellDelegate {
    func addProduct(cell: ProductTableViewCell) -> Int
    func minusProduct(cell: ProductTableViewCell) -> Int
}

class ProductTableViewCell: UITableViewCell {
    var delegate: ProductTableViewCellDelegate?
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
        let indexPath = self.delegate?.minusProduct(cell: self)
        if count < 1 {
            countLabel.text = "\(model.products[indexPath ?? 0].count + 1) in stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        } else {
            countLabel.text = "\(model.products[indexPath ?? 0].count) in stock"
            numberLabel.text = "\(count)"
            numberLabel.sizeToFit()
        }
    }
    @IBAction func plusAction(_ sender: Any) {
        count = count + 1
        let indexPath = self.delegate?.addProduct(cell: self)
        if model.products[indexPath ?? 0].count == 0{
            zeroInStock()
        } else {
            countLabel.textColor = UIColor(red: 21/255, green: 22/255, blue: 22/255, alpha: 0.5)
            countLabel.text = "\(model.products[indexPath ?? 0].count) in stock"
        }
        numberLabel.text = "\(count)"
        numberLabel.sizeToFit()
    }
    @IBAction func addAction(_ sender: Any) {
        let indexPath = self.delegate?.addProduct(cell: self)
        print(model.products[indexPath ?? 0].count)
        if model.products[indexPath ?? 0].count == 0{
            zeroInStock()
        } else {
            numberLabel.isHidden = false
            numberLabel.text = "\(count)"
            minusButton.isHidden = false
            plusButton.isHidden = false
            numberLabel.sizeToFit()
            countLabel.textColor = UIColor(red: 21/255, green: 22/255, blue: 22/255, alpha: 0.5)
            countLabel.text = "\(model.products[indexPath ?? 0].count) in stock"
        }
        count = 1
        addButton.isHidden = true
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
        descrLabel.adjustsFontSizeToFitWidth = true
        priceLabel.sizeToFit()
        if model.products[number].count == 0 {
            zeroInStock()
        } else {
            countLabel.textColor = UIColor(red: 21/255, green: 22/255, blue: 22/255, alpha: 0.5)
            countLabel.text = "\(model.products[number].count) in stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        }
        if !model.products[number].images.isEmpty{
            getImage(number)
        }
    }
    
    private func zeroInStock(){
        countLabel.textColor = UIColor(red: 182/255, green: 9/255, blue: 73/255, alpha: 1)
        countLabel.text = "Out of stock"
        numberLabel.isHidden = true
        minusButton.isHidden = true
        plusButton.isHidden = true
        addButton.isHidden = true
    }
    
    private func getImage(_ number: Int){
        var subNumber = 0
        for imageNumber in 0..<model.products[number].images.count{
            if model.products[number].images[imageNumber].front {
                
                subNumber = imageNumber
                break
            }
        }
        let semaphore = DispatchSemaphore (value: 0)
        if let url = URL(string: "http://176.119.157.195:8080/\(model.products[number].images[subNumber].url)"){
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
