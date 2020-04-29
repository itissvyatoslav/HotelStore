//
//  DevelopInfoViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class DevelopInfoViewController: UIViewController{
    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        infoLabel.text = "Create mobile apps on Android and iOS platforms, different web apps, websites.\nWe adapt to your tasks and deadlines."
    }
}
