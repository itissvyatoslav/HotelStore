//
//  BuyInfoViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 01.05.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Stripe
import UIKit
import Locksmith

@available(iOS 13.0, *)
class BuyInfoViewController: UIViewController, RequestDelegate, STPPaymentContextDelegate {
    let network = UserService()
    var summ: Double = 0
    
    private var paymentContext: STPPaymentContext? = nil
    let model = DataModel.sharedData
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBAction func payAction(_ sender: Any) {
        if roomNumberTextField.text == "" || roomNumberTextField.text == "Please, write your room number"{
            roomNumberTextField.textColor = UIColor.red
            roomNumberTextField.text = "Please, write your room number"
        } else {
            model.user.roomNumber = roomNumberTextField.text ?? ""
            model.user.firstName = nameTextField.text ?? ""
            indicatorView.isHidden = false
            self.paymentContext?.requestPayment()
            network.payOrder(roomNumber: roomNumberTextField.text ?? "", comment: commentTextView.text ?? "", name: nameTextField.text ?? "")
            DispatchQueue.main.async {
                MyAPIClient().goood()
                let vc = self.storyboard?.instantiateViewController(identifier: "SuccessPaymentVC") as! SuccessPaymentViewController
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.setRoomNumber()
                if self.model.resultOrder == true {
                    vc.id = 0
                } else {
                    vc.id = 1
                }
            }
        }
    }
    
    @IBAction func selectCard(_ sender: Any) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
 //   @IBAction func hotelListAction(_ sender: Any) {
 //           let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //           let vc = storyboard.instantiateViewController(identifier: "HotelListVC") as! //HotelListViewController
 //           self.navigationController?.pushViewController(vc, animated: true)
 //   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setStripe()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        roomNumberTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        roomNumberTextField.text = ""
        roomNumberTextField.textColor = UIColor(named: "ColorTextField")
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
    
    private func setRoomNumber(){
        do {
            try Locksmith.updateData(data: ["token" : model.token,
                   "firstName": model.user.firstName,
                   "lastName": model.user.lastName,
                   "roomNumber": model.user.roomNumber,
                   "email": model.user.email,
                   "hotelId": model.user.hotel.id,
                   "hotelName": model.user.hotel.name],
            forUserAccount: "HotelStoreAccount")
        } catch {
            print("Unable to update")
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
                    print(status)
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


