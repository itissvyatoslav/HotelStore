//
//  ActivityIndicator.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 03.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    func showActivity(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
      
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func stopActivity(){
        aView?.removeFromSuperview()
        aView = nil
    }
    
    func alertWindow(){
        let alertController = UIAlertController(
            title: "Something happened",
            message: "Try again later",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: "Close",
            style: .default,
            handler: { _ in
                alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func startIndicator(){
        let modalViewController = ModalViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: false, completion: nil)
    }
    
}

class ModalViewController: UIViewController {
    override func viewDidLoad() {
        self.showActivity()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
}
