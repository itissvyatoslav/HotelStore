//
//  FirstAgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 06.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class FirstAgreementViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @available(iOS 13.0, *)
    @IBAction func agreeAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setView(){
        self.navigationController?.title = "User agreement"
    }
}
