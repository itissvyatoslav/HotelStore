//
//  LogUserService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class LogUserService {
    func logIn(){
        
    }
    
    func registration(id: String){
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "http://176.119.157.195:8080/app/appleauth") else {
            print("url error")
            return
        }
        let parametrs = ["access_token": id]


        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
}
