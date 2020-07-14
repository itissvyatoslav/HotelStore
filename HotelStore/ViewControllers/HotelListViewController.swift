//
//  HotelListViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import CoreLocation
import Locksmith
import UIKit

class HotelListViewController: UIViewController, CLLocationManagerDelegate{
    let model = DataModel.sharedData
    let network = GetProductsService()
    @IBOutlet weak var hotelsTable: UITableView!
    @IBOutlet weak var otherHotelsTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    
    var id = 2
    
    //MARK: - START LOCATION
    
    var locationManager = CLLocationManager()
    
    func checkCoreLocationPermission(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    //tels.sort {$0.distance < $1.distance}
    
    func sortHotels(latUser: Double, lonUser: Double){
        for number in 0..<model.hotels.count{
            let lat = model.hotels[number].lat
            let lon = model.hotels[number].lon
            let distance = 2*6372795*asin(sqrt(sin((lon - lonUser)/2)*sin((lon - lonUser)/2) + cos(lonUser)*cos(lon)*sin((lat - latUser)/2)*sin((lat - latUser)/2)))
            model.hotels[number].distance = distance
        }
        model.hotels.sort {$0.distance < $1.distance}
    }
    
    // DELEGATE:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        sortHotels(latUser: locValue.latitude, lonUser: locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
    }
    //MARK: - END LOCATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setView(){
        indicatorView.isHidden = true
        indicatorView.layer.cornerRadius = 5
        self.navigationItem.title = "Point of delivery"
        hotelsTable.tableFooterView = UIView(frame: .zero)
        otherHotelsTable.tableFooterView = UIView(frame: .zero)
        otherHotelsTable.delegate = self
        otherHotelsTable.dataSource = self
        hotelsTable.delegate = self
        hotelsTable.dataSource = self
    }
    
    @available(iOS 13.0, *)
    @objc func goToAgreement(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FirstAgreementVC") as! FirstAgreementViewController
        vc.navigationItem.hidesBackButton = true
        vc.navigationController?.title = "User agreement"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HotelListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hotelsTable {
            return 1
        } else {
            if !model.hotels.isEmpty{
                return model.hotels.count - 1
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableCell")
        if tableView == hotelsTable {
            if !model.hotels.isEmpty{
                cell.textLabel?.text = model.hotels[0].name
                cell.accessoryType = .disclosureIndicator
                return cell
            } else {
                cell.textLabel?.text = "No hotels"
                return cell
            }
        } else {
            cell.textLabel?.text = model.hotels[indexPath.row + 1].name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !model.hotels.isEmpty{
            if tableView == hotelsTable {
                model.user.hotel = model.hotels[0]
            } else {
                model.user.hotel = model.hotels[indexPath.row + 1]
            }
            model.user.roomNumber = ""
            do {
                try Locksmith.updateData(data: ["token" : model.token,
                                                "firstName": model.user.firstName,
                                                "lastName": model.user.lastName,
                                                "roomNumber": model.user.roomNumber,
                                                "email": model.user.email,
                                                "hotelId": model.user.hotel.id,
                                                "hotelName": model.user.hotel.name],
                                         forUserAccount: "HotelStoreAccount")
            } catch {
                print("Unable to update")
            }
        }
        if id == 0 {
            indicatorView.isHidden = false
            DispatchQueue.main.async {
                self.tabBarController?.tabBar.items?[1].badgeValue = nil
                self.network.getCategories()
                ShoppingCartNetwork().removeCart()
                self.navigationController?.popViewController(animated: true)
            }
            //activityIndicator.stopAnimating()
        }
        if id == 1 {
            if #available(iOS 13.0, *) {
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "UserInfoVC") as! UserInfoViewController
                vc.id = 1
                vc.navigationItem.hidesBackButton = true
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(goToAgreement))
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if id == 2 {
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
