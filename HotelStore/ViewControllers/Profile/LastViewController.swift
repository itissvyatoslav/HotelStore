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
    let order = DataModel.sharedData
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderTable: UITableView!
    
    override func viewDidLoad() {
        setViews()
    }

    @IBAction func cancelOrderAction(_ sender: Any) {
    }
    
    private func setViews(){
        statusLabel.text = "Processing"
        orderNumberLabel.text = "\(order.lastOrder[order.lastOrder.count - 1].id)"
        hotelLabel.text = "\(order.lastOrder[order.lastOrder.count - 1].hotel)"
        priceLabel.text = "\(order.lastOrder[order.lastOrder.count - 1].totalPrice) S$"
        orderTable.delegate = self
        orderTable.dataSource = self
        self.orderTable.register(UINib(nibName: "ProfileLastOrderCells", bundle: nil), forCellReuseIdentifier: "ProfileLastOrderCells")
        orderTable.tableFooterView = UIView()
    }
}

extension LastViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.lastOrder[order.lastOrder.count - 1].goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLastOrderCells") as! ProfileLastOrderCells
        cell.setView(number: indexPath.row)
        return cell
    }
}
