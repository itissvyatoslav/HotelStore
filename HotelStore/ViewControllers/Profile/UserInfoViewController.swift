//
//  UserInfoViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit
import Locksmith

class UserInfoViewController: UIViewController{
    let model = DataModel.sharedData
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var id = 0
    
    override func viewDidLoad() {
        setViews()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setViews(){
        infoLabel.text = "Choose, which data\nwill be available to the system"
        nameTextField.text = "\(DataModel.sharedData.user.firstName)"
        emailTextField.text = DataModel.sharedData.user.email
    }
    
    @available(iOS 13.0, *)
    @IBAction func saveAction(_ sender: Any) {
        DataModel.sharedData.user.firstName = nameTextField.text ?? "Name"
        DataModel.sharedData.user.email = emailTextField.text ?? "@gmail.com"
        do {
            try Locksmith.updateData(data: ["token" : model.token,
                   "firstName": model.user.firstName,
                   "lastName": model.user.lastName,
                   "roomNumber": model.user.roomNumber,
                   "email": model.user.email,
                   "hotelId": model.user.hotel.id,
                   "hotelName": model.user.hotel.name],
            forUserAccount: "HotelStoreAccount")
        } catch {
            print("Unable to update")
        }
        if id == 0 {
            navigationController?.popViewController(animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "FirstAgreementVC") as! FirstAgreementViewController
            vc.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
