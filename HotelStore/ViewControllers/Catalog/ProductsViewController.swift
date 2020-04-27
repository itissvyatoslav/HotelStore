//
//  ProductsViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 27.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class ProductsViewController: UIViewController{
    let model = DataModel.sharedData
    let network = GetProductsService()
    var category_id = 0
    
    @IBOutlet weak var productsTable: UITableView!
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    @IBAction func upButtonAction(_ sender: Any) {
    }
    @IBAction func downButtonAction(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        network.getProducts(hotel_id: 5, category_id: category_id, limit: "50", page: 1, brand: "")
        setView()
    }
    
    private func setView(){
        productsTable.delegate = self
        productsTable.dataSource = self
        productsTable.tableFooterView = UIView(frame: .zero)
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell1")
        return cell
    }
    
    
}
