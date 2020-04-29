//
//  SliderCell.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 29.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class SliderCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    func setUp(image: UIImage){
        imageView.image = image
    }
}
