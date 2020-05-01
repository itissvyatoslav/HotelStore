//
//  HotelListViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class HotelListViewController: UIViewController{
    let model = DataModel.sharedData
    let network = GetHotelsService()
    @IBOutlet weak var hotelsTable: UITableView!
    @IBOutlet weak var otherHotelsTable: UITableView!
    
    override func viewDidLoad() {
        network.getHotels()
        super.viewDidLoad()
        setView()
    }
    
    private func setView(){
        self.navigationItem.title = "Point to delivery"
        hotelsTable.tableFooterView = UIView(frame: .zero)
        otherHotelsTable.tableFooterView = UIView(frame: .zero)
        otherHotelsTable.delegate = self
        otherHotelsTable.dataSource = self
        hotelsTable.delegate = self
        hotelsTable.dataSource = self
    }
}

extension HotelListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hotelsTable {
            return 1
        } else {
            return model.hotels.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableCell")
        if tableView == hotelsTable {
            cell.textLabel?.text = model.hotels[0].name
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            cell.textLabel?.text = model.hotels[indexPath.row + 1].name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == hotelsTable {
            model.currentHotel = model.hotels[0]
        } else {
            model.currentHotel = model.hotels[indexPath.row + 1]
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
