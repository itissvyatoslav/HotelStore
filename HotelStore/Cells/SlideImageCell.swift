//
//  SlideImageCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 30.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class SlideImageCell: UICollectionViewCell{
    let model = DataModel.sharedData
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setUp(_ number: Int, _ subNumber: Int){
        if let url = URL(string: "http://176.119.157.195:8080/\(model.products[number].images[subNumber].url)"){
            do {
                let data = try Data(contentsOf: url)
                self.imageView.image = UIImage(data: data)
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
            //semaphore.signal()
        }
    }
}
