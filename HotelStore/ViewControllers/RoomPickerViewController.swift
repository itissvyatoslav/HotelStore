//
//  RoomPickerViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 06.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class RoomPickerViewController: UIViewController{
    @IBOutlet weak var roomNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView(){
        self.navigationController?.title = "Room number"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(goToUserInfo))
    }
    
    @objc func goToUserInfo(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "UserInfoVC") as! UserInfoViewController
        vc.id = 1
        vc.navigationItem.hidesBackButton = true
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(goToAgreement))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToAgreement(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FirstAgreementVC") as! FirstAgreementViewController
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        goToUserInfo()
        DataModel.sharedData.user.roomNumber = roomNumberTextField.text ?? ""
    }
    
}
