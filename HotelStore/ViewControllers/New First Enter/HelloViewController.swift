//
//  HelloViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.10.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class HelloViewController: UIViewController {
    
    @IBOutlet weak var russianLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    private func setLabels(){
        russianLabel.text = "ОНЛАЙН-МАГАЗИН\nс доставкой 15 минут\nдо вашего номера в отеле"
        englishLabel.text = "ONLINE STORE\nwith 15 minutes delivery\nto your hotel room"
    }
    
    
}
