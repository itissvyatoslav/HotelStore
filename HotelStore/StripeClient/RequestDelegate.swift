//
//  RequestDelegate.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.06.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation

protocol RequestDelegate: class {
    func error_back(message: String)
    func test()
}
