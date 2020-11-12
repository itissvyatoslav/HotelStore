//
//  UserService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class UserService {
    let model = DataModel.sharedData
    
    struct answerReceiveUser: Codable {
        var data: dataReceiveUser
    }
    
    struct dataReceiveUser: Codable {
        var first_name: String?
        var id: Int
        var last_name: String?
        var orders: [dataReceive]
    }
    
    struct answerReceive: Codable{
        var data: [dataReceive]
        var message: String?
        var success: Bool
    }
    
    struct dataReceive: Codable{
        var cart: [cartType]
        var comment: String?
        var date: String
        var hotel: hotelType?
        var id: Int?
        var room: String?
        var status: String
        var time: String
    }
    
    struct hotelType: Codable{
        var address: String
        var id: Int
        var name: String
    }
    
    struct cartType: Codable{
        var cart_position_id: Int
        var order: Int
        var product: productType
        var quantity_cart: Int
        var quantity_stock: Int?
    }
    
    struct productType: Codable{
        var brand: String
        var category_id: Int?
        var id: Int
        var images: [imagesType]
        var price: Double
        var short_description: String
        var title: String
    }
    
    struct imagesType: Codable{
        var front: Bool
        var url: String
    }
    
    func getLastOrder(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/app/order")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(model.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json2 = try JSONSerialization.jsonObject(with: data, options: [])
                print(json2)
                
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.lastOrder.removeAll()
                if json.data.count != 0 {
                    self.model.status = json.data[json.data.count - 1].status
                    self.model.hotelLastOrder = json.data[json.data.count - 1].hotel?.name ?? "undefined"
                    self.model.orderNumberLast = json.data[json.data.count - 1].id ?? 0
                    for number in 0..<json.data[json.data.count - 1].cart.count{
                        self.model.addToLastOrder.brand = json.data[json.data.count - 1].cart[number].product.brand
                        self.model.addToLastOrder.name = json.data[json.data.count - 1].cart[number].product.title
                        self.model.addToLastOrder.count = json.data[json.data.count - 1].cart[number].quantity_cart
                        self.model.addToLastOrder.price = json.data[json.data.count - 1].cart[number].product.price
                        self.model.lastOrder.append(self.model.addToLastOrder)
                    }
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func getUserInfo(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/app/logined")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(model.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceiveUser.self, from: data)
                self.model.user.firstName = json.data.first_name ?? "Name"
                self.model.user.lastName = json.data.last_name ?? "Surname"
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func payOrder(roomNumber: String, comment: String, name: String){
        struct answerReceivePay: Codable{
            var data: dataReceivePay?
            var message: String?
            var success: Bool
        }
        
        struct dataReceivePay: Codable {
            var comment: String?
            var goods_list: [String]
            var order_number: Int
            var result: Bool
            var room_number: String?
        }
        
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "https://crm.hotelstore.sg/app/orderdata") else {
            print("url error")
            return
        }
        let parametrs = ["room": roomNumber, "comment": comment, "name": name]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let config = URLSessionConfiguration.default
        let additionalHeaders = [
            "Accept": "application/json",
            "cache-control": "no-cache"
        ]
        config.httpAdditionalHeaders = additionalHeaders
        
        let postString = parametrs.compactMap{(key, value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.init(configuration: config)
        session.dataTask(with: request){(data, response, error)  in
            guard let data = data else {
                print("data error")
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceivePay.self, from: data)
                print(json)
                DataModel.sharedData.orderNumber = json.data?.order_number ?? 0
            } catch {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
    
    func cancelLastOrder(){
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/app/cancelorder")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(model.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func sendPromo(promo: String, name: String, email: String, hotel: String, room: String){
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "https://crm.hotelstore.sg/app/promo") else {
            print("url error")
            return
        }
        let parametrs = ["promo": promo, "name": name, "email": email, "hotel": hotel, "room": room]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let config = URLSessionConfiguration.default
        let additionalHeaders = [
            "Accept": "application/json",
            "cache-control": "no-cache"
        ]
        config.httpAdditionalHeaders = additionalHeaders
        
        let postString = parametrs.compactMap{(key, value) -> String in
            return "\(key)=\(String(describing: value))"
        }.joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.init(configuration: config)
        session.dataTask(with: request){(data, response, error)  in
            guard let data = data else {
                print("data error")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
}
