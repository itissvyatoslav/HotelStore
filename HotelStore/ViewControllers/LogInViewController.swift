//
//  LogInViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 05.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import AuthenticationServices

@available(iOS 13.0, *)
class LogInViewController: UIViewController{
    let model = DataModel.sharedData
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.viewDidLoad()
        infoLabel.text = "Please, sign in with your\nApple ID"
        setUpButton()
    }
    
    private func setUpButton(){
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(tapAppleButton), for: .touchUpInside)
        
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor, constant: 60),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    @objc func tapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    private func goToNextVC(){
        let vc = storyboard?.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
        vc.navigationItem.hidesBackButton = true
        vc.id = 1
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(goToRoomPicker))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToRoomPicker(){
        let vc = storyboard?.instantiateViewController(identifier: "RoomPickerVC") as! RoomPickerViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 13.0, *)
extension LogInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            model.user.id = credentials.user
            model.user.firstName = credentials.fullName?.givenName ?? ""
            model.user.lastName = credentials.fullName?.familyName ?? ""
            model.user.email = credentials.email ?? ""
            
            goToNextVC()
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error", error)
    }
}

