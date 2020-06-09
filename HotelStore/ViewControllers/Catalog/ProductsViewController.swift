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
    var images = [UIImage]()
    let model = DataModel.sharedData
    let productService = ShoppingCartNetwork()
    var category_id = 0

    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var indicatorView: UIView!
    
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
        self.registerTableViewCells()
        setView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if model.catalogInd == 1 {
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "CatalogVC") as! CatalogViewController
                self.navigationController?.pushViewController(vc, animated: true)
                model.catalogInd = 0
            }
        } else {
            indicatorView.isHidden = true
            GetProductsService().getProducts(hotel_id: model.user.hotel.id, category_id: category_id, limit: "50", page: 1, brand: "")
            productsTable.reloadData()
        }
    }
    
    private func setView(){
            indicatorView.layer.cornerRadius = 5
            self.navigationItem.backBarButtonItem?.title = ""
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
    
    //MARK: - Images Cache
    
    private func getImages(_ number: Int){
        if !self.model.products[number].images.isEmpty{
            self.images.removeAll()
            for subNumber in 0..<self.model.products[number].images.count{
                if let url = URL(string: "http://176.119.157.195:8080/\(self.model.products[number].images[subNumber].url)"){
                    if let cachedImage = self.model.imageCache.object(forKey: url.absoluteString as NSString){
                        self.images.append(cachedImage)
                    } else {
                        do {
                            let data = try Data(contentsOf: url)
                            self.images.append(UIImage(data: data)!)
                            self.model.imageCache.setObject(UIImage(data: data)!, forKey: url.absoluteString as NSString)
                        } catch let err {
                            print("Error: \(err.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    private func addToShopCart(product: DataModel.GoodsType){
        var status = 0
        for number in 0..<model.shopCart.count{
            if product.id == model.shopCart[number].id {
                model.shopCart[number].actualCount = model.shopCart[number].actualCount! + 1
                status = 1
                break
            }
        }
        if status == 0 {
            model.shopCart.append(product)
            model.shopCart[model.shopCart.count - 1].actualCount = 1
        }
    }
    
    private func removeFromShopCart(product: DataModel.GoodsType){
        for number in 0..<model.shopCart.count{
            if product.id == model.shopCart[number].id {
                model.shopCart[number].actualCount = model.shopCart[number].actualCount! - 1
                break
            }
        }
    }
    
    private func badgeValue() -> Int{
        var count: Int = 0
        for number in 0..<model.shopCart.count{
            count = count + model.shopCart[number].actualCount!
        }
        return count
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? ProductTableViewCell {
            cell.setView(indexPath.row)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            indicatorView.isHidden = false
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(identifier: "ProductPageVC") as! ProductPageViewController
                vc.navigationItem.title = " "
                self.getImages(indexPath.item)
                vc.category_id = self.category_id
                vc.number = indexPath.row
                vc.images = self.images
                self.navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension ProductsViewController: ProductTableViewCellDelegate{
    func addProduct(cell: ProductTableViewCell) -> Int {
        let cellIndex = self.productsTable.indexPath(for: cell)!.row
        productService.addProduct(product_id: model.products[cellIndex].id, hotel_id: model.user.hotel.id, indexPath: cellIndex)
        addToShopCart(product: model.products[cellIndex])
        if badgeValue() == 0 {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = "\(badgeValue())"
        }
        return cellIndex
    }
    
    func minusProduct(cell: ProductTableViewCell) -> Int {
        let cellIndex = self.productsTable.indexPath(for: cell)!.row
        //if model.products[cellIndex].actualCount == 1
        productService.minusPosition(product_id: model.products[cellIndex].id, indexPath: cellIndex)
        removeFromShopCart(product: model.products[cellIndex])
        if badgeValue() == 0 {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = "\(badgeValue())"
        }
        return cellIndex
    }
}
