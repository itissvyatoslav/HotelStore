//
//  CatalogViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 10.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class CatalogViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews(){
        self.title = "Current Hotel"
        self.navigationItem.title = "Catalog"
    }
}
