//
//  SberService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 06.09.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class SberService {
    let model = DataModel.sharedData
    
    struct PaymentCheck: Codable {
        var data: DataReceive
        var message: String?
        var success: Bool
    }
    
    struct DataReceive: Codable {
        var goods_list: [String]
        var order_number: Int
        var result: Bool
        var room_number: String?
        var status_update: String?
    }
    
    func checkPayment(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/app/paymenconfirmsber")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(model.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(PaymentCheck.self, from: data)
                print(json)
                self.model.resultOrder = json.data.result
                self.model.orderNumber = json.data.order_number
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
