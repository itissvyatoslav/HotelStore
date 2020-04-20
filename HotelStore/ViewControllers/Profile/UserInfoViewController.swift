//
//  UserInfoViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class UserInfoViewController: UIViewController{
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        setViews()
    }
    private func setViews(){
        infoLabel.text = "Choose, which data\nwill be available to the system"
        nameTextField.text = "Name"
        emailTextField.text = "Email"
    }
    
    @IBAction func saveAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
