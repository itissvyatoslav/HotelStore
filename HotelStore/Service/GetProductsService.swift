//
//  GetCategoryService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class GetProductsService {
    let model = DataModel.sharedData
    
    func getCategories(){
        
        struct answerReceive: Codable{
            var data: [dataReceive]?
            var message: String?
            var success: Bool
        }
        
        struct dataReceive: Codable{
            var id: Int
            var name: String
            var sub_categoryes: [dataReceive]
        }
        
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/app/category?hotel_id=\(model.user.hotel.id)")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue(model.token, forHTTPHeaderField: "token")
        print(model.token)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.categories.removeAll()
                if json.data == nil {
                    self.model.tokenMessage = json.message ?? ""
                } else {
                    for number in 0..<json.data!.count{
                        self.model.addCategory.sub_categoryes.removeAll()
                        for subNumber in 0..<json.data![number].sub_categoryes.count{
                            self.model.addSubcategory.id = json.data![number].sub_categoryes[subNumber].id
                            self.model.addSubcategory.name = json.data![number].sub_categoryes[subNumber].name
                            self.model.addCategory.sub_categoryes.append(self.model.addSubcategory)
                        }
                        self.model.addCategory.id = json.data![number].id
                        self.model.addCategory.name = json.data![number].name
                        self.model.categories.append(self.model.addCategory)
                    }
                }
                print("MESSAGE: //////", json.message)
            } catch {
                print(error)
            }
            self.model.categories.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func getProducts(hotel_id: Int, category_id: Int, limit: String?, page: Int, brand: String?){
        struct answerReceive: Codable{
            var data: [dataReceive]
            var message: String?
            var success: Bool
        }
        
        struct dataReceive: Codable{
            var hotel: hotelType
            var id: Int
            var product: productType
            var quantity: Int
        }
        
        struct hotelType: Codable{
            var address: String
            var id: Int
            var name: String
        }
        
        struct productType: Codable{
            var brand: String
            var category_id: Int
            var description: String
            var id: Int
            var images: [imagesType]
            var price: Double
            var quantity: Int
            var short_description: String
            var title: String
        }
        
        struct imagesType: Codable{
            var front: Bool
            var url: String
        }
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://crm.hotelstore.sg/app/product?hotel_id=\(hotel_id)&category_id=\(category_id)&limit=\(limit ?? "")&page=\(page)&brand=\(brand ?? "")")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue(model.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.products.removeAll()
                for number in 0..<json.data.count{
                    if json.data[number].quantity != 0 {
                        self.model.addProduct.id = json.data[number].product.id
                        self.model.addProduct.brand = json.data[number].product.brand
                        self.model.addProduct.name = json.data[number].product.title
                        self.model.addProduct.price = json.data[number].product.price
                        self.model.addProduct.count = json.data[number].quantity
                        self.model.addProduct.short_description = json.data[number].product.short_description
                        self.model.addProduct.description = json.data[number].product.description
                        self.model.addProduct.images.removeAll()
                        for subNumber in 0..<json.data[number].product.images.count{
                            self.model.addImage.front = json.data[number].product.images[subNumber].front
                            self.model.addImage.url = json.data[number].product.images[subNumber].url
                            self.model.addProduct.images.append(self.model.addImage)
                        }
                        self.model.products.append(self.model.addProduct)
                    }
                }
            } catch {
                print(error)
            }
            self.model.products.sort {$0.price > $1.price}
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
