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
import PyrusServiceDesk

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate, NewReplySubscriber{
    
    func onNewReply() {
        print("New message")
    }
    
    let model = DataModel.sharedData
    let network = UserService()
    
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
    
    @IBAction func liveChatTapped(_ sender: Any) {
        setChatRoom()
    }
    
    
    let labels = ["User info", "Last order", "User Agreement", "F.A.Q."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "ColorSubText")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        PyrusServiceDesk.unsubscribeFromReplies(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicatorView.isHidden = true
        nameLabel.text = DataModel.sharedData.user.firstName.uppercased()
        buttonHotel.setTitle(model.user.hotel.name, for: .normal)
        self.tabBarController?.tabBar.isHidden = false
        PyrusServiceDesk.subscribeToReplies(self)
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
        if MFMailComposeViewController.canSendMail(){
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["support@hotelstore.sg"])
            present(composer, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            controller.dismiss(animated: true, completion: nil)
        case .saved:
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            controller.dismiss(animated: true, completion: nil)
        @unknown default:
            print("default")
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
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
                //indicatorView.isHidden = false
                DispatchQueue.main.async {
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
        if indexPath.item == 3{
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "FAQViewController") as! FAQViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
