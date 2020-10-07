//
//  YandexAnalytics.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 08.10.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import YandexMobileMetrica

class YandexAnalytics {
    
    let params : [String : Any] = ["Platform": "iOS"]
    let paramsStripe : [String : Any] = ["Platform": "iOS", "Payment": "Stripe"]
    let paramsSber : [String : Any] = ["Platform": "iOS", "Payment": "Sber"]
    
    func sendAgreement(){
        YMMYandexMetrica.reportEvent("Agreement Tapped", parameters: self.params, onFailure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func sendBuy(){
        YMMYandexMetrica.reportEvent("Buy Button Tapped", parameters: self.params, onFailure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func sendPayStripe(){
        YMMYandexMetrica.reportEvent("Pay Button Tapped", parameters: self.paramsStripe, onFailure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func sendPaySber(){
        YMMYandexMetrica.reportEvent("Pay Button Tapped", parameters: self.paramsSber, onFailure: { (error) in
            print(error.localizedDescription)
        })
    }
}
