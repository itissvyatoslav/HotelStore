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
        var quantity_stock: Int?
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
    
    func getCart(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/app/cart")!,timeoutInterval: Double.infinity)
        
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
                    self.model.addProduct.actualCount = json.data.cart[number].quantity_cart
                    self.model.addProduct.count = json.data.cart[number].quantity_stock ?? 0
                    self.model.addProduct.images.removeAll()
                    for subNumber in 0..<json.data.cart[number].product.images.count{
                        self.model.addImage.url = json.data.cart[number].product.images[subNumber].url
                        self.model.addProduct.images.append(self.model.addImage)
                    }
                    self.model.shopCart.append(self.model.addProduct)
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func removeCart(){
        //let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "https://crm.hotelstore.sg/app/cart") else {
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
            //semaphore.signal()
        }.resume()
        //semaphore.wait()
    }
    
    func addProduct(product_id: Int, hotel_id: Int, indexPath: Int) {
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "https://crm.hotelstore.sg/app/cart") else {
            print("url error")
            return
        }
        let parametrs = ["product_id": product_id, "hotel_id": hotel_id]

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
                let json2 = try JSONSerialization.jsonObject(with: data, options: [])
                print(json2)
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                for number in 0..<self.model.products.count{
                    if json.data.cart[number].product.id == product_id {
                        self.model.products[indexPath].count = json.data.cart[number].quantity_stock ?? 0
                        break
                    }
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }

    func removeProduct(product_id: Int){
        //let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "https://crm.hotelstore.sg/app/cart/remove?product_id=\(product_id)") else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
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
            //semaphore.signal()
        }.resume()
        //semaphore.wait()
    }
    
    func minusPosition(product_id: Int, indexPath: Int){
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "https://crm.hotelstore.sg/app/cart?product_id=\(product_id)") else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error)  in
            guard let data = data else {
                    print("data error")
                    return
            }
            do {
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                for number in 0..<self.model.products.count{
                    if json.data.cart[number].product.id == product_id {
                        self.model.products[indexPath].count = json.data.cart[number].quantity_stock ?? 0
                        break
                    }
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
}
