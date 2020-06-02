//
//  FirstAgreementViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 06.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class FirstAgreementViewController: UIViewController{
    override func viewWillAppear(_ animated: Bool) {
        guard let url = URL(string: "http://127.0.0.1:5000/document/policy.pdf") else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @available(iOS 13.0, *)
    @IBAction func agreeAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
        vc.navigationItem.hidesBackButton = true
        print("user.id: ", DataModel.sharedData.user.id)
       // network.registration(id: DataModel.sharedData.user.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setView(){
        self.navigationController?.title = "User agreement"
    }
}

extension FirstAgreementViewController: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
    }
}
