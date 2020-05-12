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
        var id: Int
        var images: [ImagesType]
        var name: String
        var count: Int
        var price: Double
        var short_description: String
        var description: String
    }
    
    struct ImagesType{
        var front: Bool
        var url: String
    }
    
    struct HotelType {
        var name: String
        var id: Int
        var lat: Double
        var lon: Double
    }
    
    struct LastOrderGood {
        var name: String
        var count: Int
        var price: Double
    }
    
    var products = [GoodsType]()
    var addProduct = GoodsType(id: 0, images: [], name: "", count: 0, price: 0, short_description: "", description: "")
    var addImage = ImagesType(front: false, url: "")
    
    var shopCart = [GoodsType]()
    
    struct Category {
        var id: Int
        var name: String
        var sub_categoryes: [Category]
    }
    
    struct User {
        var id: String
        var firstName: String
        var lastName: String
        var email: String
        var hotel: HotelType
        var roomNumber: String
    }
    
    var categories = [Category]()
    var addCategory = Category(id: 0, name: "", sub_categoryes: [])
    var addSubcategory = Category(id: 0, name: "", sub_categoryes: [])
    
    var hotels = [HotelType]()
    var addHotel = HotelType(name: "", id: 0, lat: 0, lon: 0)
    
    var user = User(id: "", firstName: "Leyla", lastName: "", email: "@mail.ru", hotel: HotelType(name: "", id: 0, lat: 0, lon: 0), roomNumber: "")
    var token = "4c28cd9a411caf7af982bd7bedd95ddf46cbf2a7"
    
    
    var lastOrder = [LastOrderGood]()
    var addToLastOrder = LastOrderGood(name: "", count: 0, price: 0)
    var status = ""
    var hotelLastOrder = ""
    var orderNumber = 0
    
    
    static let sharedData = DataModel()
}
