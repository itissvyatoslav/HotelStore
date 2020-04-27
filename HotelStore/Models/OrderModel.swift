//
//  OrderModel.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 13.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class OrderModel {
    
    struct OrderDescription {
        var id: Int
        var hotel: String
        var totalPrice: Int
        var goods: [Goods]
    }
    
    struct Goods {
        var image: String
        var name: String
        var count: Int
        var price: Int
    }
    
    var lastOrder = [OrderDescription(id: 23, hotel: "Current hotel", totalPrice: 49, goods: [Goods(image: "", name: "Oral-B, electric toothbrush Vitality 3D White", count: 1, price: 5)])]
    
    var shoppingCart = [Goods(image: "", name: "Oral-B, electric toothbrush Vitality 3D White", count: 1, price: 23), Goods(image: "", name: "Pillow", count: 3, price: 14)]
    
    struct Category{
        var id: Int
        var name: String
        var sub_categoryes: [Category]
    }
    
    var categories = [Category]()
    var addCategory = Category(id: 0, name: "", sub_categoryes: [])
    var addSubcategory = Category(id: 0, name: "", sub_categoryes: [])
    
    static let sharedData = OrderModel()
}
