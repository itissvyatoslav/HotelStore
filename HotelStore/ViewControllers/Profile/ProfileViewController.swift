//
//  ProfileViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 10.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ProfileViewController: UIViewController{
    let network = GetProductsService()
    
    @IBOutlet weak var tableView: UITableView!
    
    let labels = ["User info", "Last order", "User Agreement", "About the developer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        network.getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setViews(){
        self.navigationItem.title = "Current Hotel"
        self.tabBarItem.title = "Profile"
        //tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = false
        tableView.dataSource = self
        tableView.delegate = self

    }
    @IBAction func feedBackAction(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.setToRecipients(["support@hotelstore.sg"])
        
        present(composer, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableCell")
        cell.textLabel?.text = labels[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0{
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "UserInfoVC") as! UserInfoViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.item == 1{
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "LastVC") as! LastViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.item == 2{
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "AgreementVC") as! AgreementViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.item == 3{
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "DevelopInfoVC") as! DevelopInfoViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


