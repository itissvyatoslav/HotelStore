//
//  StripeViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 13.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import Stripe

class StripeViewController: UIViewController, STPPaymentContextDelegate{
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
       // self.activityIndicator.animating = paymentContext.loading
       // self.paymentButton.enabled = paymentContext.selectedPaymentOption != nil
       // self.paymentLabel.text = paymentContext.selectedPaymentOption?.label
       // self.paymentIcon.image = paymentContext.selectedPaymentOption?.image
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    let customerContext = STPCustomerContext(keyProvider: StripeClientAPI())
    let paymentContext: STPPaymentContext?
    
    init() {
        self.paymentContext = STPPaymentContext(customerContext: customerContext)
        super.init(nibName: nil, bundle: nil)
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        self.paymentContext?.paymentAmount = 5000 // This is in cents, i.e. $50 USD
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
