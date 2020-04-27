//
//  GetCategoryService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class GetProductsService {
    let model = OrderModel.sharedData
    
    func getCategories(){
        
        struct answerReceive: Codable{
            var data: [dataReceive]
            var message: String?
            var success: Bool
        }
        
        struct dataReceive: Codable{
            var id: Int
            var name: String
            var sub_categoryes: [dataReceive]
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
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.categories.removeAll()
                for number in 0..<json.data.count{
                    self.model.addCategory.sub_categoryes.removeAll()
                    for subNumber in 0..<json.data[number].sub_categoryes.count{
                        self.model.addSubcategory.id = json.data[number].sub_categoryes[subNumber].id
                        self.model.addSubcategory.name = json.data[number].sub_categoryes[subNumber].name
                        self.model.addCategory.sub_categoryes.append(self.model.addSubcategory)
                    }
                    self.model.addCategory.id = json.data[number].id
                    self.model.addCategory.name = json.data[number].name
                    self.model.categories.append(self.model.addCategory)
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func getProducts(hotel_id: String, category_id: String?, limit: String?, page: String?, brand: String?){
        struct answerReceive: Codable{
        }
        
        struct dataReceive: Codable{
        }
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "http://176.119.157.195:8080/app/product?hotel_id=\(hotel_id)&category_id=\(category_id ?? "")&limit=\(limit ?? "")&page=\(page ?? "")&brand=\(brand ?? "")")!,timeoutInterval: Double.infinity)
        
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
