//
//  BuyInfoViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class BuyInfoViewController: UIViewController{
    let model = DataModel.sharedData
    
    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBAction func payAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView(){
        nameTextField.placeholder = model.name
        hotelLabel.text = model.currentHotel.name
    }
}
