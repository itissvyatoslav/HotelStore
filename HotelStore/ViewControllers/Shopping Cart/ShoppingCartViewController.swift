//
//  ShoppingCartViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 10.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class ShoppingCartViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews(){
        self.navigationItem.title = "Shopping cart"
        self.tabBarItem.title = "Shopping cart"
        tabBarController?.tabBar.items?[1].badgeValue = "4"
    }
}
