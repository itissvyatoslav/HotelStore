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
    
    struct answerReceive: Codable{
        var data: dataReceive
        var message: String?
        var success: Bool
    }
    
    struct dataReceive: Codable{
        var token: String
    }
    
    func logIn(){
        
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
                DataModel.sharedData.token = json.data.token
                print(json)
            } catch {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
}
