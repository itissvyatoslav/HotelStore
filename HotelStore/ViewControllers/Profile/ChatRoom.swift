//
//  ChatRoom.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 08.10.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import PyrusServiceDesk
import UIKit

extension ProfileViewController: OnStopCallback {
    func onStop() {
        navigationController?.popViewController(animated: true)
    }
    
    func setChatRoom(){
        let configure : ServiceDeskConfiguration = ServiceDeskConfiguration.init()
        configure.userName = model.user.firstName
        configure.chatTitle = "HotelStore Support"
        configure.welcomeMessage = "Hello! How can I help you?"
        configure.themeColor = UIColor(red: 182/255, green: 9/255, blue: 73/255, alpha: 1)
        configure.avatarForSupport = UIImage.init(named: "profile30")

        
        PyrusServiceDesk.start(on: self, configuration:configure)
    }
}
