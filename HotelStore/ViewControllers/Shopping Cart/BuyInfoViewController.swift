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
import PassKit

@available(iOS 13.0, *)
class BuyInfoViewController: UIViewController, RequestDelegate, STPPaymentContextDelegate, UITextFieldDelegate {
    
    var isBackFromSber = false
    let network = UserService()
    var summ: Double = 0
    
    private var paymentContext: STPPaymentContext? = nil
    let model = DataModel.sharedData
    
    let localesSNG = ["AZ", "RU", "BE", "HY", "KK", "KY", "ru_MD", "TG", "UZ"]
    
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
            YandexAnalytics().sendPayStripe()
            model.user.roomNumber = roomNumberTextField.text ?? ""
            model.user.firstName = nameTextField.text ?? ""
            indicatorView.isHidden = false
            self.paymentContext?.requestPayment()
            //MyAPIClient().goood()
            //semaphore.signal()
            //semaphore.wait()
            
            network.payOrder(roomNumber: roomNumberTextField.text ?? "", comment: commentTextView.text ?? "", name: nameTextField.text ?? "")
            //MyAPIClient().createPayment()
            if model.intentSuccess {
                DispatchQueue.main.async {
                    MyAPIClient().makePayment()
                    if self.model.requires_payment_method == "requires_payment_method" {

                    } else {
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
        }
    }
    
    @IBAction func selectCard(_ sender: Any) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        paySber.isHidden = true
        let locale = Locale.current
        print(locale.regionCode)
        if localesSNG.contains(locale.regionCode ?? "") {
            setSber()
        } else {
            setStripe()
        }
        //setStripe()
        //setSber()
        super.viewDidLoad()
        setView()
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
        self.nameTextField.delegate = self
        self.roomNumberTextField.delegate = self
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
    
    //MARK: - STRIPE DELEGATE
    
    @IBOutlet weak var methodButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    
    
    func error_back(message: String) {
    }
    
    func test() {
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        //MyAPIClient().createPayment()
        MyAPIClient().createPaymentIntent { (data) in
            if let clientSecret = data{
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                    print(status)
                    switch status {
                    case .succeeded:
                        print("success")
                        completion(.success, nil)
                        MyAPIClient().makePayment()
                        let vc = self.storyboard?.instantiateViewController(identifier: "SuccessPaymentVC") as! SuccessPaymentViewController
                        vc.navigationItem.hidesBackButton = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.setRoomNumber()
                        if self.model.resultOrder == true {
                            vc.id = 0
                        } else {
                            vc.id = 1
                        }
                    case .failed:
                        print("failed")
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
        indicatorView.isHidden = true
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print("I tried3")
    }
    
    // MARK:- SBER
    @IBAction func paySber(_ sender: Any) {
        if roomNumberTextField.text == "" || roomNumberTextField.text == "Please, write your room number" {
            roomNumberTextField.textColor = UIColor.red
            roomNumberTextField.text = "Please, write your room number"
        } else {
            YandexAnalytics().sendPaySber()
            self.network.payOrder(roomNumber: self.roomNumberTextField.text ?? "", comment: self.commentTextView.text ?? "", name: self.nameTextField.text ?? "")
            model.user.roomNumber = roomNumberTextField.text ?? ""
            model.user.firstName = nameTextField.text ?? ""
            let vc = self.storyboard?.instantiateViewController(identifier: "SberViewController") as! SberViewController
            vc.delegate = self
            vc.urlString = "https://crm.hotelstore.sg/app/paymentsberbank"
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var paySber: UIButton!
    @IBOutlet weak var heightApplePay: NSLayoutConstraint!
    
    private func setSber(){
        methodButton.isHidden = true
        payButton.isHidden = true
        paySber.isHidden = false
        heightApplePay.constant = heightApplePay.constant - 53
        //setApplePayButton()
    }
    
    //MARK:- Apple Pay Sber
    
    private func setApplePayButton(){
        let applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .whiteOutline)
        applePayButton.translatesAutoresizingMaskIntoConstraints = false
        applePayButton.addTarget(self, action: #selector(tapApplePayButton), for: .touchUpInside)
        
        view.addSubview(applePayButton)
        NSLayoutConstraint.activate([
            applePayButton.centerXAnchor.constraint(equalTo: methodButton.centerXAnchor),
            applePayButton.centerYAnchor.constraint(equalTo: methodButton.centerYAnchor),
            applePayButton.leadingAnchor.constraint(equalTo: methodButton.leadingAnchor),
            applePayButton.trailingAnchor.constraint(equalTo: methodButton.trailingAnchor)
        ])
    }
    
    @objc func tapApplePayButton(){
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var applePayImage: UIImageView!
    
    private var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.HotelStore"
        request.supportedNetworks = [.visa, .masterCard]
        request.supportedCountries = ["RU"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "RU"
        request.currencyCode = "RUB"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Order", amount: NSDecimalNumber(value: Int(DataModel.sharedData.globalPrice)))]
        return request
    }()
}

@available(iOS 13.0, *)
extension BuyInfoViewController: SberDelegate, PKPaymentAuthorizationViewControllerDelegate{
    
    func backFromSber() {
        navigationController?.popViewController(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
           completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
       }
    
       func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
           controller.dismiss(animated: true, completion: nil)
       }
}


