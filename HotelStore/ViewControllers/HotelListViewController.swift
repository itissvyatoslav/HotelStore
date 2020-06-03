//
//  HotelListViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import CoreLocation
import UIKit

class HotelListViewController: UIViewController{
    let model = DataModel.sharedData
    let network = GetHotelsService()
    @IBOutlet weak var hotelsTable: UITableView!
    @IBOutlet weak var otherHotelsTable: UITableView!
    var id = 2
    
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
            model.user.hotel = model.hotels[0]
        } else {
            model.user.hotel = model.hotels[indexPath.row + 1]
        }
        
        if id == 0 {
            navigationController?.popViewController(animated: true)
        }
        if id == 1 {
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "RoomPickerVC") as! RoomPickerViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if id == 2 {
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
