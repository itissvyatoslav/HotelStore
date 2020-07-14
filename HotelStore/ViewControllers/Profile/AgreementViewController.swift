//
//  AgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import WebKit
import UIKit

class AgreementViewController: UIViewController, WKNavigationDelegate{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        setView()
        webView.navigationDelegate = self
    }
    
    private func setView(){
        self.tabBarController?.tabBar.isHidden = true
        setPDF()
    }
    
    private func setPDF(){
        if let url = URL(string: "https://crm.hotelstore.sg/document/policy"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
