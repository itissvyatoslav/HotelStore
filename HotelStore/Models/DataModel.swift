//
//  OrderModel.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 13.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class DataModel {
    
    struct OrderDescription {
        var id: Int
        var hotel: String
        var totalPrice: Int
        var goods: [GoodsType]
    }
    
    struct GoodsType {
        var images: [ImagesType]
        var name: String
        var count: Int
        var price: Int
        var short_description: String
    }
    
    struct ImagesType{
        var front: Bool
        var url: String
    }
    
    var products = [GoodsType]()
    var addProduct = GoodsType(images: [], name: "", count: 0, price: 0, short_description: "")
    var addImage = ImagesType(front: false, url: "")
    
    struct Category{
        var id: Int
        var name: String
        var sub_categoryes: [Category]
    }
    
    var categories = [Category]()
    var addCategory = Category(id: 0, name: "", sub_categoryes: [])
    var addSubcategory = Category(id: 0, name: "", sub_categoryes: [])
    
    static let sharedData = DataModel()
}
