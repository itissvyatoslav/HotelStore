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
    let model = DataModel.sharedData
    
    @IBOutlet weak var shoppingCartTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        network.getCart()
    }
    
    private func setViews(){
        shoppingCartTable.reloadData()
        self.navigationItem.title = "Shopping cart"
        self.tabBarItem.title = "Shopping cart"
        shoppingCartTable.tableFooterView = UIView(frame: .zero)
        tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
        registerTableViewCells()
        shoppingCartTable.delegate = self
        shoppingCartTable.dataSource = self
    }
    
    private func registerTableViewCells() {
        let shoppingCell = UINib(nibName: "ShoppingCartCell",
                                  bundle: nil)
        self.shoppingCartTable.register(shoppingCell,
                                forCellReuseIdentifier: "ShoppingCartCell")
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.shopCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell") as? ShoppingCartCell {
            cell.setCell(indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}
