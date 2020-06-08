//
//  SuccessPaymentViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.06.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class SuccessPaymentViewController: UIViewController{
    
    @available(iOS 13.0, *)
    @IBAction func backAction(_ sender: Any) {
        activityView.isHidden = false
        DataModel.sharedData.catalogInd = 1
        self.tabBarController?.selectedIndex = 0
        let vc = storyboard?.instantiateViewController(identifier: "ShoppingCartViewController") as! ShoppingCartViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        activityView.layer.cornerRadius = 5
        activityView.isHidden = true
        DataModel.sharedData.shopCart.removeAll()
        tabBarController?.tabBar.items?[1].badgeValue = "0"
        ShoppingCartNetwork().removeCart()
        super.viewDidLoad()
        infoLabel.text = "Your order is accepted.\nOrder number is"
        numberLabel.text = "\(DataModel.sharedData.orderNumber)"
    }
}
