//
//  FirstAgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 06.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import WebKit
import UIKit

class FirstAgreementViewController: UIViewController, WKNavigationDelegate{
    let network = LogUserService()
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.title = "User agreement"
    }
    
    @available(iOS 13.0, *)
    @IBAction func agreeAction(_ sender: Any) {
        network.registration(id: DataModel.sharedData.user.id)
        let vc = storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
        vc.navigationItem.hidesBackButton = true
        print("user.id: ", DataModel.sharedData.user.id)
       // network.registration(id: DataModel.sharedData.user.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setView(){
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
