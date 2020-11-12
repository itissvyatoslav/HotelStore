//
//  CoronaViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 11.10.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class CoronaViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var russianLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    private func setLabels(){
        russianLabel.text = "B связи  с новой вспышкой \nраспространения коронавирусной\nинфекции сервис в целях безопасности\nгостей временно не работает! Приносим\nизвинения за доставленные неудобства."
        englishLabel.text = "Due to a new outbreak of coronavirus \ninfection, the service is temporarily closed\nfor the safety of guests! We apologize for\nany inconvenience "
    }
}
