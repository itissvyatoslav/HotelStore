//
//  SberViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.09.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import WebKit

class SberViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var urlString = ""
    var delegate: SberDelegate?
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.backFromSber()
    }
    
    override func viewDidLoad() {
        DataModel.sharedData.backFromSber = true
        super.viewDidLoad()
        setWebView()
    }
    
    private func setWebView(){
        webView.navigationDelegate = self
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}

protocol SberDelegate {
    func backFromSber()
}
