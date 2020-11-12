//
//  NewAgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.10.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import WebKit

class NewAgreementViewController: UIViewController{
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPDF()
    }
    
    private func setPDF(){
        if let url = URL(string: "https://crm.hotelstore.sg/document/policy"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
