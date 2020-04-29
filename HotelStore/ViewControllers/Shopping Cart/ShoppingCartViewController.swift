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
    let network = ShoppingCartNetwork()
    
    @IBOutlet weak var shoppingCartTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        network.getCart()
        //network.addProduct(product_id: "2", hotel_id: "2")
        network.getCart()
    }
    
    private func setViews(){
        self.navigationItem.title = "Shopping cart"
        self.tabBarItem.title = "Shopping cart"
        shoppingCartTable.tableFooterView = UIView(frame: .zero)
        tabBarController?.tabBar.items?[1].badgeValue = "4"
    }
}
