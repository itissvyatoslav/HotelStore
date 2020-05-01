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
        super.viewDidLoad()
        self.delegate = self
        catalogViewController = CatalogViewController()
        shoppingCartViewController = ShoppingCartViewController()
        profileViewController = ProfileViewController()
        setImages()
    }
    
    private func setImages(){
        profileViewController.tabBarItem.image = UIImage(named: "Vector-10")
        profileViewController.tabBarItem.selectedImage = UIImage(named: "Vector-11")
    }
}
