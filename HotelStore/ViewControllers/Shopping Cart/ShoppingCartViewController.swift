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
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var emptyButton: UIButton!
    
    @IBAction func removeCartAction(_ sender: Any) {
        network.removeCart()
        model.shopCart.removeAll()
        checkButton()
        shoppingCartTable.reloadData()
        priceLabel.text = "0.0S$"
        tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.registerTableViewCells()
        setViews()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.getCart()
        shoppingCartTable.reloadData()
        checkButton()
        tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
        setGlobalPrice()
    }
    
    private func setViews(){
        shoppingCartTable.reloadData()
        self.navigationItem.title = "Shopping cart"
        self.tabBarItem.title = "Shopping cart"
        shoppingCartTable.tableFooterView = UIView(frame: .zero)
        tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
        shoppingCartTable.delegate = self
        shoppingCartTable.dataSource = self
        checkButton()
    }
    
    private func registerTableViewCells() {
        let shoppingCell = UINib(nibName: "ShoppingCartCell",
                                  bundle: nil)
        self.shoppingCartTable.register(shoppingCell,
                                forCellReuseIdentifier: "ShoppingCartCell")
    }
    
    private func checkButton(){
        if model.shopCart.isEmpty {
            buyButton.isHidden = true
            emptyButton.isHidden = false
        } else {
            buyButton.isHidden = false
            emptyButton.isHidden = true
        }
    }
    
    private func setGlobalPrice(){
        var summ: Double = 0
        for number in 0..<model.shopCart.count{
            summ = summ + model.shopCart[number].price * Double(model.shopCart[number].actualCount ?? 0)
        }
        priceLabel.text = "\(Double(round(1000*summ)/1000))S$"
    }
    
    private func removeFromShopCart(cellNumber: Int){
        model.shopCart[cellNumber].actualCount = model.shopCart[cellNumber].actualCount! - 1
        if model.shopCart[cellNumber].actualCount == 0 {
            model.shopCart.remove(at: cellNumber)
        }
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.shopCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell") as? ShoppingCartCell {
            cell.setCell(indexPath.row)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension ShoppingCartViewController: ShoppingCartCellDelegate{
    func addProduct(cell: ShoppingCartCell) -> Int {
        let cellIndex = self.shoppingCartTable.indexPath(for: cell)!.row
        if model.shopCart[cellIndex].count != 0 {
            model.shopCart[cellIndex].actualCount = model.shopCart[cellIndex].actualCount! + 1
            model.shopCart[cellIndex].count = model.shopCart[cellIndex].count - 1
            network.addProduct(product_id: model.shopCart[cellIndex].id, hotel_id: model.user.hotel.id, indexPath: cellIndex)
            tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
            setGlobalPrice()
        }
            return cellIndex
    }
    
    func minusProduct(cell: ShoppingCartCell) -> Int {
        let cellIndex = self.shoppingCartTable.indexPath(for: cell)!.row
        network.minusPosition(product_id: model.shopCart[cellIndex].id, indexPath: cellIndex)
        removeFromShopCart(cellNumber: cellIndex)
        if model.shopCart.isEmpty {
            checkButton()
            shoppingCartTable.reloadData()
            setGlobalPrice()
            tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
            return -1
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
            model.shopCart[cellIndex].count = model.shopCart[cellIndex].count + 1
            setGlobalPrice()
            return cellIndex
        }
    }
    
    func deleteProduct(cell: ShoppingCartCell){
        let cellIndex = self.shoppingCartTable.indexPath(for: cell)!.row
        network.removeProduct(product_id: model.shopCart[cellIndex].id)
        model.shopCart.remove(at: cellIndex)
        shoppingCartTable.reloadData()
        setGlobalPrice()
        tabBarController?.tabBar.items?[1].badgeValue = "\(model.shopCart.count)"
        checkButton()
    }
}
