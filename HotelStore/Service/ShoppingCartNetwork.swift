//
//  ShoppingCartNetwork.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class ShoppingCartNetwork{
    let model = DataModel.sharedData
    
    func getCart(){
        
        struct answerReceive: Codable{
            var data: dataReceive
            var message: String?
            var success: Bool
        }
        
        struct dataReceive: Codable{
            var cart: [cartReceive]
            var comment: String?
            var date: String
            var hotel: hotelReceive
            var id: Int
            var room: String
            var status: String
            var time: String
        }
        
        struct cartReceive: Codable{
            var cart_position_id: Int
            var order: Int
            var product: productReceive
            var quantity_cart: Int
            var quantity_stock: Int
        }
        
        struct productReceive: Codable{
            var brand: String
            var category_id: Int
            var id: Int
            var images: [imageReceive]
            var price: Double
            var short_description: String
            var title: String
        }
        
        struct imageReceive: Codable{
            var front: Bool
            var url: String
        }
        
        struct hotelReceive: Codable{
            var address: String
            var id: Int
            var name: String
        }
        
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "http://176.119.157.195:8080/app/cart")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.shopCart.removeAll()
                for number in 0..<json.data.cart.count{
                    self.model.addProduct.id = json.data.cart[number].product.id
                    self.model.addProduct.name = json.data.cart[number].product.title
                    self.model.addProduct.price = json.data.cart[number].product.price
                    self.model.addProduct.count = json.data.cart[number].quantity_cart
                    self.model.addProduct.images.removeAll()
                    for subNumber in 0..<json.data.cart[number].product.images.count{
                        if json.data.cart[number].product.images[subNumber].front{
                            self.model.addImage.url = json.data.cart[number].product.images[subNumber].url
                            self.model.addProduct.images.append(self.model.addImage)
                        }
                    }
                    self.model.shopCart.append(self.model.addProduct)
                }
                print(json)
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func removeCart(){
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "http://176.119.157.195:8080/app/cart") else {
            print("url error")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error)  in
            guard let httpResponse = response as? HTTPURLResponse, let _ = data
                else {
                    print("error: not a valid http response")
                    return
            }
            switch (httpResponse.statusCode) {
            case 200: //success response.
                break
            case 400:
                break
            default:
                break
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
    
    func addProduct(product_id: Int, hotel_id: Int?) {
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "http://176.119.157.195:8080/app/cart") else {
            print("url error")
            return
        }
        let parametrs = ["product_id": product_id, "hotel_id": hotel_id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else {
            print("JSON error")
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
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

    func removeProduct(product_id: String){
        
    }
}
