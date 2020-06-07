//
//  getHotelsService.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 20.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

class GetHotelsService{
    let model = DataModel.sharedData
    
    struct answerReceive: Codable{
        var data: [dataReceive]
        var message: String?
        var success: Bool
    }
    
    struct dataReceive: Codable{
        var address: String
        var id: Int
        var location: locationType
        var managers: [managerType]
        var name: String
    }
    
    struct locationType: Codable{
        var lat: Double
        var lon: Double
    }
    
    struct managerType: Codable{
        var id: Int
        var name: String
    }
    
    func getHotels(){
        var request = URLRequest(url: URL(string: "http://176.119.157.195:8080/app/hotel?sort=name&page=1&limit=50")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue(model.token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.hotels.removeAll()
                for number in 0..<json.data.count{
                    self.model.addHotel.id = json.data[number].id
                    self.model.addHotel.name = json.data[number].name
                    self.model.addHotel.lon = json.data[number].location.lon
                    self.model.addHotel.lat = json.data[number].location.lat
                    self.model.hotels.append(self.model.addHotel)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getHotelsSem(){
        let semaphore = DispatchSemaphore (value: 0)
        
        let token = "b8c48440ca23482c97feef3acf78b855a01fd197"
        var request = URLRequest(url: URL(string: "http://176.119.157.195:8080/app/hotel?sort=name&page=1&limit=50")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSONDecoder().decode(answerReceive.self, from: data)
                self.model.hotels.removeAll()
                for number in 0..<json.data.count{
                    self.model.addHotel.id = json.data[number].id
                    self.model.addHotel.name = json.data[number].name
                    self.model.addHotel.lon = json.data[number].location.lon
                    self.model.addHotel.lat = json.data[number].location.lat
                    self.model.hotels.append(self.model.addHotel)
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
