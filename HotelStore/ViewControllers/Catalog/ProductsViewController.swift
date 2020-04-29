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
        model.products.sort {$0.price < $1.price}
        productsTable.reloadData()
    }
    @IBAction func downButtonAction(_ sender: Any) {
        model.products.sort {$0.price > $1.price}
        productsTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        network.getProducts(hotel_id: 5, category_id: category_id, limit: "50", page: 1, brand: "")
        //productsTable.register(UINib(nibName: "ProductMiniCell", bundle: nil), forCellReuseIdentifier: "ProductMiniCell")
        self.registerTableViewCells()
        setView()
    }
    override func viewWillAppear(_ animated: Bool) {
        productsTable.reloadData()
    }
    
    private func setView(){
        productsTable.delegate = self
        productsTable.dataSource = self
        productsTable.tableFooterView = UIView(frame: .zero)
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "ProductTableViewCell",
                                  bundle: nil)
        self.productsTable.register(textFieldCell,
                                forCellReuseIdentifier: "ProductTableViewCell")
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ProductMiniCell") as! ProductMiniCell
        //cell.setView(indexPath.row)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? ProductTableViewCell {
            cell.setView(indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(identifier: "ProductPageVC") as! ProductPageViewController
            vc.number = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
