//
//  FirstAgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 06.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import WebKit
import UIKit
import Locksmith

class FirstAgreementViewController: UIViewController, WKNavigationDelegate{
    let model = DataModel.sharedData
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityView.isHidden = true
        self.navigationController?.title = "User agreement"
    }
    
    @available(iOS 13.0, *)
    @IBAction func agreeAction(_ sender: Any) {

        do {
            try Locksmith.updateData(data: ["token" : model.token,
                                          "firstName": model.user.firstName,
                                          "lastName": model.user.lastName,
                                          "roomNumber": model.user.roomNumber,
                                          "email": model.user.email,
                                          "hotelId": model.user.hotel.id,
                                          "hotelName": model.user.hotel.name],
                                   forUserAccount: "HotelStoreAccount")
            print("saved!")
        } catch {
            print("Unable to save data")
        }
        activityView.isHidden = false
        DispatchQueue.main.async {
            GetProductsService().getCategories()
            let vc = self.storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
            vc.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        print("user.id: ", DataModel.sharedData.user.id)
        
    }
    
    private func setView(){
        activityView.layer.cornerRadius = 5
        self.navigationController?.title = "User agreement"
        setPDF()
    }
    
    private func setPDF(){
        if let url = URL(string: "http://176.119.157.195:8080/document/policy"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
