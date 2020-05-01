//
//  CatalogViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 10.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class CatalogViewController: UIViewController{
    let network = GetProductsService()
    let model = DataModel.sharedData

    @IBAction func HotelListAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var catalogTable: UITableView!
    
    override func viewDidLoad() {
        network.getCategories()
        super.viewDidLoad()
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title =  model.currentHotel.name
    }
    
    private func setViews(){
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
                let vc = storyboard?.instantiateViewController(identifier: "ProductsVC") as! ProductsViewController
                vc.category_id = model.categories[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = storyboard?.instantiateViewController(identifier: "SubCatalogVC") as! SubCatalogViewController
                vc.number = indexPath.row
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
