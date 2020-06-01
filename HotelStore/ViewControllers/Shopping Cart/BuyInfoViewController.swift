//
//  BuyInfoViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Stripe
import UIKit

class BuyInfoViewController: UIViewController{
    let model = DataModel.sharedData
    
    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBAction func payAction(_ sender: Any) {
        
    }
    @IBAction func hotelListAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hotelLabel.text = model.user.hotel.name
    }
    
    private func setView(){
        nameTextField.text = model.user.firstName
        roomNumberTextField.text = model.user.roomNumber
    }
}


