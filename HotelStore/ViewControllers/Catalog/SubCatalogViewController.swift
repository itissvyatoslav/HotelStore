//
//  SubCatalogViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 26.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class SubCatalogViewController: UIViewController{
    let model = DataModel.sharedData
    var number = 0
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var catalogTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        indicatorView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setViews(){
        indicatorView.layer.cornerRadius = 5
        self.navigationItem.backBarButtonItem?.title = ""
        //self.navigationItem.title = model.user.hotel.name
        self.tabBarItem.title = "Catalog"
        catalogTable.delegate = self
        catalogTable.dataSource = self
        catalogTable.tableFooterView = UIView(frame: .zero)
    }
}

extension SubCatalogViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.categories[number].sub_categoryes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        cell.textLabel?.text = model.categories[number].sub_categoryes[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            indicatorView.isHidden = false
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(identifier: "ProductsVC") as! ProductsViewController
                vc.category_id = self.model.categories[self.number].sub_categoryes[indexPath.row].id
                vc.navigationItem.title = self.model.categories[self.number].sub_categoryes[indexPath.row].name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

