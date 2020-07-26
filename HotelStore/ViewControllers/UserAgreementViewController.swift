//
//  UserAgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 17.07.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import WebKit

class UserAgreementViewController: UIViewController, WKNavigationDelegate{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
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


