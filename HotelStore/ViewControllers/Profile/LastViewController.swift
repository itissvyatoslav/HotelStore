//
//  LastViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 13.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class LastViewController: UIViewController {
    let network = UserService()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }

    
    private func setViews(){
        statusLabel.text = DataModel.sharedData.status
        orderNumberLabel.text = "\(DataModel.sharedData.orderNumberLast)"
        hotelLabel.text = DataModel.sharedData.hotelLastOrder
        setPriceLabel()
        orderTable.delegate = self
        orderTable.dataSource = self
        self.orderTable.register(UINib(nibName: "ProfileLastOrderCells", bundle: nil), forCellReuseIdentifier: "ProfileLastOrderCells")
        orderTable.tableFooterView = UIView()
    }
    
    private func setPriceLabel(){
        var summ: Double = 0
        for number in 0..<DataModel.sharedData.lastOrder.count{
            summ = summ + DataModel.sharedData.lastOrder[number].price
        }
        priceLabel.text = "\(summ)\(DataModel.sharedData.currency)"
    }
}

extension LastViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.sharedData.lastOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLastOrderCells") as! ProfileLastOrderCells
        cell.setView(number: indexPath.row)
        return cell
    }
}
