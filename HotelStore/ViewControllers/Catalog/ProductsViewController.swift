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
    
    private func getImages(_ number: Int){
        let semaphore = DispatchSemaphore (value: 0)
        for subNumber in 0..<model.products[number].images.count{
            if let url = URL(string: "http://176.119.157.195:8080/\(model.products[number].images[subNumber].url)"){
                do {
                    print(subNumber)
                    let data = try Data(contentsOf: url)
                    images.append(UIImage(data: data)!)
                } catch let err {
                    print("Error: \(err.localizedDescription)")
                }
                
            }
            semaphore.signal()
        }
        semaphore.wait()
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
            getImages(indexPath.item)
            vc.number = indexPath.row
            vc.images = images
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
