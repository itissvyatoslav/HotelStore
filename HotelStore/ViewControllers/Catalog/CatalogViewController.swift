//
//  CatalogViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 10.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit
import Locksmith

class CatalogViewController: UIViewController{
    let network = GetProductsService()
    let getHotels = GetHotelsService()
    let model = DataModel.sharedData

    @IBAction func HotelListAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            vc.id = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func tappedButtonHotel(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            vc.id = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var buttonHotel: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var catalogTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHotels.getHotels()
        setViews()
        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonHotel.setTitle(model.user.hotel.name, for: .normal)
        indicatorView.isHidden = true
        //self.navigationItem.title =  model.user.hotel.name
        catalogTable.reloadData()
    }
    
    private func setViews(){
        indicatorView.isHidden = true
        indicatorView.layer.cornerRadius = 5
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.title = model.user.hotel.name
        self.tabBarItem.title = "Catalog"
        catalogTable.delegate = self
        catalogTable.dataSource = self
        catalogTable.tableFooterView = UIView(frame: .zero)
    }
}

extension CatalogViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        cell.textLabel?.text = model.categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if model.categories[indexPath.item].sub_categoryes.isEmpty{
                indicatorView.isHidden = false
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(identifier: "ProductsVC") as! ProductsViewController
                    vc.category_id = self.model.categories[indexPath.row].id
                    vc.navigationItem.title = self.model.categories[indexPath.row].name
                    //self.network.getProducts(hotel_id: self.model.user.hotel.id, category_id: self.model.categories[indexPath.row].id, limit: "50", page: 1, brand: "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let vc = storyboard?.instantiateViewController(identifier: "SubCatalogVC") as! SubCatalogViewController
                vc.number = indexPath.row
                vc.navigationItem.title = model.categories[indexPath.row].name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
