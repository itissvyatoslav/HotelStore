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
    @IBOutlet weak var brandLabel: UILabel!
    
    
    @IBAction func minusAction(_ sender: Any) {
        count = count - 1
        let indexPath = self.delegate?.minusProduct(cell: self)
        if count < 1 {
            countLabel.textColor = UIColor(named: "ColorSubText")
            countLabel.text = "\(model.products[indexPath ?? 0].count + 1) in stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        } else {
            countLabel.textColor = UIColor(named: "ColorSubText")
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
            countLabel.textColor = UIColor(named: "ColorSubText")
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
            countLabel.textColor = UIColor(named: "ColorSubText")
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageProduct.image = nil
    }
    
    func setView(_ number: Int){
        nameLabel.text = model.products[number].name
        brandLabel.text = model.products[number].brand
        descrLabel.text = model.products[number].short_description
        priceLabel.text = "\(model.products[number].price)S$"
        nameLabel.sizeToFit()
        descrLabel.sizeToFit()
        descrLabel.adjustsFontSizeToFitWidth = true
        priceLabel.sizeToFit()
        if model.products[number].count == 0 {
            zeroInStock()
        } else {
            countLabel.textColor = UIColor(named: "ColorSubText")
            countLabel.text = "\(model.products[number].count) in stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        }
        //if !model.products[number].images.isEmpty{
            //getImage(number)
            imageProduct.layer.cornerRadius = 15
        //}
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
        
        if let url = URL(string: "https://crm.hotelstore.sg/\(model.products[number].images[subNumber].url)"){
            if let cachedImage = model.imageCache.object(forKey: url.absoluteString as NSString){
                self.imageProduct.image = cachedImage
            } else {
                do {
                    let data = try Data(contentsOf: url)
                    self.imageProduct.image = UIImage(data: data)
                } catch let err {
                    print("Error: \(err.localizedDescription)")
                }
            }
        }
    }
}
