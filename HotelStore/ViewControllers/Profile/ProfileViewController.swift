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
    let model = DataModel.sharedData
    let network = UserService()
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func HotelListAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            vc.id = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    let labels = ["User info", "Last order", "User Agreement"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicatorView.isHidden = true
        nameLabel.text = DataModel.sharedData.user.firstName.uppercased()
        self.navigationItem.title = model.user.hotel.name
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setViews(){
        indicatorView.layer.cornerRadius = 5
        self.tabBarItem.image = UIImage(named: "profileblack")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.tabBarItem.title = "Profile"
        self.tabBarController?.tabBar.isHidden = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
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
        return 3
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
                indicatorView.isHidden = false
                DispatchQueue.main.async {
                    self.network.getUserInfo()
                    let vc = self.storyboard?.instantiateViewController(identifier: "UserInfoVC") as! UserInfoViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        if indexPath.item == 1{
            if #available(iOS 13.0, *) {
                indicatorView.isHidden = false
                DispatchQueue.main.async {
                    self.network.getLastOrder()
                    let vc = self.storyboard?.instantiateViewController(identifier: "LastVC") as! LastViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        if indexPath.item == 2{
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "AgreementVC") as! AgreementViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


