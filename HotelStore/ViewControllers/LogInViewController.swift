//
//  LogInViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 05.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import AuthenticationServices
import CoreLocation

@available(iOS 13.0, *)
class LogInViewController: UIViewController, CLLocationManagerDelegate{
    let model = DataModel.sharedData
    let network = LogUserService()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var signinLabel: UILabel!
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "ColorSubText")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.viewDidLoad()
        infoLabel.text = "Please, sign in with your\nApple ID"
        signinLabel.text = "Log in to make purchases without leaving your hotel room and receive your items in just several minutes."
        setUpButton()
    }
    
    private func setUpButton(){
        let appleButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
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
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        GetHotelsService().getHotelsSem()
        let vc = storyboard?.instantiateViewController(identifier: "HelloViewController") as! HelloViewController
        vc.navigationItem.hidesBackButton = true
        //vc.id = 1
        //vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skip))
        self.navigationController?.pushViewController(vc, animated: true)
        print("buy buy")
    }
    
    @objc func skip(){
        let vc = self.storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Location
    var locationManager = CLLocationManager()
    
    func checkCoreLocationPermission(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func sortHotels(latUser: Double, lonUser: Double){
        for number in 0..<model.hotels.count{
            let lat = model.hotels[number].lat
            let lon = model.hotels[number].lon
            let distance = 2*6372795*asin(sqrt(sin((lon - lonUser)/2)*sin((lon - lonUser)/2) + cos(lonUser)*cos(lon)*sin((lat - latUser)/2)*sin((lat - latUser)/2)))
            model.hotels[number].distance = distance
        }
        print("we are sorting!!!")
        model.hotels.sort {$0.distance < $1.distance}
        print(model.hotels)
    }
    
    // DELEGATE:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        sortHotels(latUser: locValue.latitude, lonUser: locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
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
            
            model.user.id = String(data: credentials.authorizationCode!, encoding: .utf8)!
            //model.user.id = credentials.user
            model.user.firstName = credentials.fullName?.givenName ?? ""
            model.user.lastName = credentials.fullName?.familyName ?? ""
            model.user.email = credentials.email ?? ""
            network.registration(id: DataModel.sharedData.user.id)
            goToNextVC()
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error", error)
    }
}

