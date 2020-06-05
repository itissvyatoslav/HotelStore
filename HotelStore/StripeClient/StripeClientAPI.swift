//
//  StripeClientAPI.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 13.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import Stripe

struct StringValue{
    static let m_url = "http://176.119.157.195:8080"
    static let ephemeral_key_method = "/app/ephemeralkey"
    static let payment_intent_method = "/app/paymentintent"
    static let sabmit_method = "/app/paymenconfirm"
}

struct StripeKeys{
    static let publishable_key = "pk_test_iYRLqXMkAbUQ6fy1jLxBNche00HMlyTpKf"
    static let secret_key = "sk_test_RRItqHjbeFAYAyX53nSB7uZ500KM0pa34J"
}

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    public enum HTTPMethod: String {
        case get
        case POST
        case put
        case delete
    }
    
    struct answerReceive: Codable{
        var data: dataReceive
        var message: String?
        var success: Bool
    }
    
    struct dataReceive: Codable {
        var comment: String?
        var goods_list: [String]
        var order_number: Int
        var result: Bool
        var room_number: String?
    }
    
    private let build_main_url = { (method: String)-> URL in
        return URL(string: "\(StringValue.m_url)\(method)")!
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = build_main_url(StringValue.ephemeral_key_method)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??)
                 else {
                completion(nil, error)
                return
            }
            let d_response = json!["data"] as? [String: Any]
            if let s = d_response {
                let f_response = s["ephemeral_key"] as? [String: Any]
                completion(f_response, nil)
            }
            
        })
        task.resume()
    }
    
    func createPaymentIntent(completion: @escaping (String?) -> Void){
        let url = build_main_url(StringValue.payment_intent_method)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                return
            }
            if let response_text = json{
                let data = response_text["data"] as? [String: String]
                if let d = data{
                    completion(d["client_secret"])
                }else{
                    completion(nil)
                }
            }
            
        })
        task.resume()
    }
    
    func goood(){
        let semaphore = DispatchSemaphore (value: 0)
        let url = build_main_url(StringValue.sabmit_method)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json2 = try JSONSerialization.jsonObject(with: data, options: [])
                print(json2)
                
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                DataModel.sharedData.resultOrder = json.data.result
                DataModel.sharedData.orderNumber = json.data.order_number
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func complitePayment(completion: @escaping (Bool, Int) -> Void){
        let semaphore = DispatchSemaphore (value: 0)
        let url = build_main_url(StringValue.sabmit_method)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(DataModel.sharedData.token, forHTTPHeaderField: "token")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                return
            }
            
            if let response_text = json{
                let data = response_text["data"] as? [String: Any]
                if let d = data{
                    completion(d["result"] as! Bool, d["order_number"] as! Int)
                }else{
                    completion(false, 0)
                }
            }
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
    }
}

