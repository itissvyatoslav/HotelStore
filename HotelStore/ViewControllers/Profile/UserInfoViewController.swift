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
        nameTextField.text = DataModel.sharedData.name
        emailTextField.text = DataModel.sharedData.email
    }
    
    @IBAction func saveAction(_ sender: Any) {
        DataModel.sharedData.name = nameTextField.text ?? DataModel.sharedData.name
        DataModel.sharedData.email = emailTextField.text ?? DataModel.sharedData.email
        navigationController?.popViewController(animated: true)
    }
    
}
