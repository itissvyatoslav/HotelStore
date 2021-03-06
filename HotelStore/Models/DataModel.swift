//
//  OrderModel.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 13.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

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
        var actualCount: Int?
        var brand: String
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
        var distance: Double
    }
    
    struct LastOrderGood {
        var name: String
        var count: Int
        var price: Double
        var brand: String
    }
    
    var products = [GoodsType]()
    var addProduct = GoodsType(id: 0, images: [], name: "", count: 0, price: 0, short_description: "", description: "", brand: "")
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
    var addHotel = HotelType(name: "", id: 0, lat: 0, lon: 0, distance: 0)
    
    var user = User(id: "", firstName: "Leyla", lastName: "", email: "@gmail.com", hotel: HotelType(name: "", id: 0, lat: 0, lon: 0, distance: 0), roomNumber: "")
    var token = "default token"
    var deviceToken = ""
    
    var lastOrder = [LastOrderGood]()
    var addToLastOrder = LastOrderGood(name: "", count: 0, price: 0, brand: "")
    var status = ""
    var hotelLastOrder = ""
    var resultOrder = false
    var orderNumberLast = 0
    var orderNumber = 0
    var globalPrice: Double = 0
    var catalogInd = 0

    static let sharedData = DataModel()
    
    func addToShopCart(product: GoodsType){
        var status = 0
        for number in 0..<DataModel.sharedData.shopCart.count{
            if product.id == DataModel.sharedData.shopCart[number].id {
                print(DataModel.sharedData.shopCart[number])
                DataModel.sharedData.shopCart[number].actualCount = DataModel.sharedData.shopCart[number].actualCount ?? 0 + 1
                status = 1
                break
            }
        }
        if status == 0 {
            DataModel.sharedData.shopCart.append(product)
        }
    }
    
    var tokenMessage :String? = ""
    
    var imageCache = NSCache<NSString, UIImage>()
    var intentSuccess = false
    var requires_payment_method = "not_requires_payment_method"
    
    struct faqStruct {
        var answer: String?
        var id: Int?
        var question: String?
    }
    
    var addFaq = faqStruct(answer: "", id: 0, question: "")
    var faq = [faqStruct]()
    
    var backFromSber = false
    
    var currency: String {
        let locale = Locale.current
        let localesSNG = ["AZ", "RU", "BE", "HY", "KK", "KY", "ru_MD", "TG", "UZ"]
        if localesSNG.contains(locale.regionCode ?? "nil") {
            return "₽"
        } else {
            return "S$"
        }
    }
}
