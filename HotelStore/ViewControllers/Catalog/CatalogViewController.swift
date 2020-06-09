//
//  CatalogViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 10.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import CoreLocation
import UIKit
import Locksmith

class CatalogViewController: UIViewController, CLLocationManagerDelegate{
    let network = GetProductsService()
    let getHotels = GetHotelsService()
    let model = DataModel.sharedData

    @IBAction func HotelListAction(_ sender: Any) {
        goToHotelList()
    }
    
    @IBAction func tappedButtonHotel(_ sender: Any) {
        goToHotelList()
    }
    
    @objc private func goToHotelList(){
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            vc.id = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var buttonHotel: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var catalogTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "ColorSubText")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonHotel.setTitle(model.user.hotel.name, for: .normal)
        indicatorView.isHidden = true
        //self.navigationItem.title =  model.user.hotel.name
        catalogTable.reloadData()
    }
    
    private func setViews(){
        indicatorView.isHidden = true
        indicatorView.layer.cornerRadius = 5
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.title = model.user.hotel.name
        self.tabBarItem.title = "Catalog"
        catalogTable.delegate = self
        catalogTable.dataSource = self
        catalogTable.tableFooterView = UIView(frame: .zero)
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

extension CatalogViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        cell.textLabel?.text = model.categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if model.categories[indexPath.item].sub_categoryes.isEmpty{
                indicatorView.isHidden = false
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(identifier: "ProductsVC") as! ProductsViewController
                    vc.category_id = self.model.categories[indexPath.row].id
                    vc.navigationItem.title = self.model.categories[indexPath.row].name
                    //self.network.getProducts(hotel_id: self.model.user.hotel.id, category_id: self.model.categories[indexPath.row].id, limit: "50", page: 1, brand: "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let vc = storyboard?.instantiateViewController(identifier: "SubCatalogVC") as! SubCatalogViewController
                vc.number = indexPath.row
                vc.navigationItem.title = model.categories[indexPath.row].name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
