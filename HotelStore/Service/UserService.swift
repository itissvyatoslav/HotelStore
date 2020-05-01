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
    
    func getLastOrder(){
        struct answerReceive: Codable{
            var data: [dataReceive]
            var message: String?
            var success: Bool
        }
        
        struct dataReceive: Codable{
            var cart: [cartType]
            var comment: String
            var date: String
            var hotel: hotelType
            var id: Int
            var room: String
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
            var quantity_stock: Int
        }
        
        struct productType: Codable{
            var brand: String
            var category_id: Int
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
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "http://176.119.157.195:8080/app/order")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("4b775da95b3f8538e0d87f29e038ec428384b81d", forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.lastOrder.removeAll()
                if json.data.count != 0 {
                    self.model.status = json.data[json.data.count - 1].status
                    self.model.hotelLastOrder = json.data[json.data.count - 1].hotel.name
                    self.model.orderNumber = json.data[json.data.count - 1].cart[0].order
                    for number in 0..<json.data[json.data.count - 1].cart.count{
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
}
