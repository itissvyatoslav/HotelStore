//
//  LogUserService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class LogUserService {
    
    let model = DataModel.sharedData
    
    struct answerReceive: Codable{
        var data: dataReceive?
        var message: String?
        var success: Bool
    }
    
    struct dataReceive: Codable{
        var token: String
    }
    
    func getFAQ(){
        struct answerReceiveFAQ: Codable{
            var data: [dataReceiveFAQ]
            var message: String?
            var success: Bool
        }
        
        struct dataReceiveFAQ: Codable{
            var answer: String?
            var id: Int?
            var question: String?
        }
        
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/api/faq")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceiveFAQ.self, from: data)
                for number in 0..<json.data.count {
                    self.model.addFaq.answer = json.data[number].answer
                    self.model.addFaq.id = json.data[number].id
                    self.model.addFaq.question = json.data[number].question
                    self.model.faq.append(self.model.addFaq)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getFAQSemophore(){
        
        struct answerReceiveFAQ: Codable{
            var data: [dataReceiveFAQ]
            var message: String?
            var success: Bool
        }
        
        struct dataReceiveFAQ: Codable{
            var answer: String?
            var id: Int?
            var question: String?
        }
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/api/faq")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceiveFAQ.self, from: data)
                for number in 0..<json.data.count {
                    self.model.addFaq.answer = json.data[number].answer
                    self.model.addFaq.id = json.data[number].id
                    self.model.addFaq.question = json.data[number].question
                    self.model.faq.append(self.model.addFaq)
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func registration(id: String){
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "https://crm.hotelstore.sg/app/appleauth") else {
            print("url error")
            return
        }
        let parametrs = ["access_token": id, "device_token": DataModel.sharedData.deviceToken]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
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
                
                
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                DataModel.sharedData.token = json.data?.token ?? "default token"
                print(json)
            } catch {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
}
