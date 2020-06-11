//
//  BuyInfoViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Stripe
import UIKit

@available(iOS 13.0, *)
class BuyInfoViewController: UIViewController, RequestDelegate, STPPaymentContextDelegate {
    let network = UserService()
    var summ: Double = 0
    
    private var paymentContext: STPPaymentContext? = nil
    let model = DataModel.sharedData
    
    @IBAction func hotelNameTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            vc.id = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBAction func payAction(_ sender: Any) {
        indicatorView.isHidden = false
        self.paymentContext?.requestPayment()
        network.payOrder(roomNumber: roomNumberTextField.text ?? "", comment: commentTextView.text ?? "")
        DispatchQueue.main.async {
            MyAPIClient().goood()
            let vc = self.storyboard?.instantiateViewController(identifier: "SuccessPaymentVC") as! SuccessPaymentViewController
            vc.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)
            if self.model.resultOrder == true {
                vc.successLabel.text = "Success"
                vc.numberLabel.text = "\(DataModel.sharedData.orderNumber)"
                vc.infoLabel.text = "Your order is accepted.\nOrder number is"
            } else {
                vc.successLabel.text = "Error"
                vc.numberLabel.text = ":("
                vc.infoLabel.text = "Sorry, we cant accept\nyour order."
            }
        }
        
    }
    
    @IBAction func selectCard(_ sender: Any) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
    @IBAction func hotelListAction(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! HotelListViewController
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setStripe()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hotelLabel.text = model.user.hotel.name
        indicatorView.isHidden = true
    }
    
    private func setView(){
        indicatorView.layer.cornerRadius = 5
        nameTextField.text = model.user.firstName
        roomNumberTextField.text = model.user.roomNumber
        setGlobalPrice()
        self.navigationItem.title = "Checkout"
    }
    
    private func setStripe(){
        self.navigationItem.rightBarButtonItem?.title = "Done"
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        self.paymentContext = STPPaymentContext(customerContext: customerContext)
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        self.paymentContext?.paymentAmount = Int(DataModel.sharedData.globalPrice * 100) //это для примера, вообще это на сервере устанавливается
        
    }
    
    private func setGlobalPrice(){
        for number in 0..<model.shopCart.count{
            summ = summ + model.shopCart[number].price * Double(model.shopCart[number].actualCount ?? 0)
        }
    }
    
    //MARK: - DELEGATE
    func error_back(message: String) {
    }
    
    func test() {
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        MyAPIClient().createPaymentIntent { (data) in
            if let clientSecret = data{
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                    switch status {
                    case .succeeded:
                        completion(.success, nil)
                    case .failed:
                        completion(.error, error)
                    case .canceled:
                        print("cancel")
                        completion(.userCancellation, nil)
                    @unknown default:
                        completion(.error, nil)
                    }
                }
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print(status)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
    }
}


