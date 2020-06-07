//
//  CustomTabBarController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController:  UITabBarController, UITabBarControllerDelegate {
    var catalogViewController: CatalogViewController!
    var shoppingCartViewController: ShoppingCartViewController!
    var profileViewController: ProfileViewController!
    
    override func viewDidLoad(){
        self.navigationItem.title =  DataModel.sharedData.user.hotel.name
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        self.delegate = self
        catalogViewController = CatalogViewController()
        shoppingCartViewController = ShoppingCartViewController()
        profileViewController = ProfileViewController()
        setImages()
    }
    
    private func setImages(){
        profileViewController.tabBarItem.image = UIImage(named: "profileblack")
        profileViewController.tabBarItem.selectedImage = UIImage(named: "profilered")
        catalogViewController.tabBarItem.image = UIImage(named: "catalogblack")
        catalogViewController.tabBarItem.selectedImage = UIImage(named: "catalogred")
        shoppingCartViewController.tabBarItem.image = UIImage(named: "cartblack")
        shoppingCartViewController.tabBarItem.selectedImage = UIImage(named: "cartred")
    }
}
