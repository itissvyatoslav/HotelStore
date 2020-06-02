//
//  ShoppingCartCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

protocol ShoppingCartCellDelegate {
    func addProduct(cell: ShoppingCartCell) -> Int
    func minusProduct(cell: ShoppingCartCell) -> Int
    func deleteProduct(cell: ShoppingCartCell)
}

class ShoppingCartCell: UITableViewCell {
    let model = DataModel.sharedData
    var delegate: ShoppingCartCellDelegate?
    var globalNumber = 0
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBAction func minusButton(_ sender: Any) {
        let indicator = self.delegate?.minusProduct(cell: self)
        if indicator == -1{
        } else {
            setCell(indicator!)
        }
    }
    @IBAction func plusButton(_ sender: Any) {
        setCell((self.delegate?.addProduct(cell: self))!)
    }
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.deleteProduct(cell: self)
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
        countLabel.text = "\(model.shopCart[number].actualCount ?? 0)"
        print(model.shopCart[number].actualCount ?? 0)
        countLabel.sizeToFit()
        priceLabel.text = "\(model.shopCart[number].price)S$"
        setImage(number)
    }
    
    private func setImage(_ number: Int){
        if !model.shopCart[number].images.isEmpty{
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
}
