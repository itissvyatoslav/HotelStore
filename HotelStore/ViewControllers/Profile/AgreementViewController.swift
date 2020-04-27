//
//  AgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class AgreementViewController: UIViewController{
    override func viewDidLoad() {
        setView()
    }
    
    private func setView(){
        self.tabBarController?.tabBar.isHidden = true
    }
}
