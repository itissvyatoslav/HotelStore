//
//  GetCategoryService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class GetCategoryService {
    func getGer(){
        
        struct answerReceive: Codable{
            var status: Int
            var data: [dataReceive]
        }
        
        struct dataReceive: Codable{
            var id: String
            var device_name: String
            var description: String
            var cost: String
            var installment_plan: String?
            var installment_cost: String?
            var device_img: String
            var order_descr: String
            var order_descr_installment: String
        }
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "http://176.119.157.195:8080/app/category")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        
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
}
