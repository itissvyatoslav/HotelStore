//
//  ShoppingCartNetwork.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class ShoppingCartNetwork{
    func getCart(){
        
        struct answerReceive: Codable{
        }
        
        struct dataReceive: Codable{
        }
        
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "http://176.119.157.195:8080/app/cart")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue("4b775da95b3f8538e0d87f29e038ec428384b81d", forHTTPHeaderField: "token")
        
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
        request.addValue("4b775da95b3f8538e0d87f29e038ec428384b81d", forHTTPHeaderField: "token")
        
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
        request.addValue("4b775da95b3f8538e0d87f29e038ec428384b81d", forHTTPHeaderField: "token")
        
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
