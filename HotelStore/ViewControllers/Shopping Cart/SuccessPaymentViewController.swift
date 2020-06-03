//
//  SuccessPaymentViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.06.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class SuccessPaymentViewController: UIViewController{
    
    @available(iOS 13.0, *)
    @IBAction func backAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = "Your order is accepted.\nOrder number is"
        numberLabel.text = "\(DataModel.sharedData.orderNumber)"
    }
}
