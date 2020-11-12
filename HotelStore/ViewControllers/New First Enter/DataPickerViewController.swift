//
//  DataPickerViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 12.10.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import Locksmith

class DataPickerViewController: UIViewController {
    
    let model = DataModel.sharedData
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var promoTextField: UITextField!
    @IBOutlet weak var russianLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var notTickButton: UIButton!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var activityView: UIView!
    
    
    struct Hotel {
        var name: String
        var id: Int
    }

    var selectedHotel = Hotel(name: DataModel.sharedData.hotels[0].name, id: DataModel.sharedData.hotels[0].id)
    
    var isTicked = false
    var isPickerChanged = false
    
    @IBAction func notTickAction(_ sender: Any) {
        YandexAnalytics().sendAgreement()
        isTicked = true
        notTickButton.isHidden = true
        tickButton.isHidden =  false
    }
    
    @IBAction func tickAction(_ sender: Any) {
        isTicked = false
        notTickButton.isHidden = false
        tickButton.isHidden = true
    }
    
    @IBAction func hotelNameTapped(_ sender: Any) {
        view.endEditing(true)
        isPickerChanged = false
        backgroundView.isHidden = false
        pickerView.isHidden = false
        picker.dataSource = self
        picker.delegate = self
        pickerView.layer.cornerRadius = 15
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if isPickerChanged {
            selectedHotel = Hotel(name: model.hotels[0].name, id: model.hotels[0].id)
        }
        hotelNameLabel.text = selectedHotel.name
        pickerView.isHidden = true
        backgroundView.isHidden = true
    }
    
    
    @available(iOS 13.0, *)
    @IBAction func saveAction(_ sender: Any) {
        var isOK = true
        
        if emailTextField.text == "" || emailTextField.text == "Please, write your e-mail" {
            emailTextField.textColor = UIColor.red
            emailTextField.text = "Please, write your e-mail"
            isOK =  false
        }
        if numberTextField.text == "" || numberTextField.text == "Please, write your room number" {
            numberTextField.textColor = UIColor.red
            numberTextField.text = "Please, write your room number"
            isOK =  false
        }
        if !isTicked {
            notTickButton.shake(duration: 0.7)
            isOK =  false
        }
        
        if isOK {
            
            model.user.roomNumber = numberTextField.text!
            model.user.firstName = nameTextField.text ?? ""
            model.user.email =  emailTextField.text!
            model.user.hotel.id = selectedHotel.id
            model.user.hotel.name = selectedHotel.name
            do {
                try Locksmith.updateData(data: ["token" : model.token,
                                              "firstName": model.user.firstName,
                                              "lastName": model.user.lastName,
                                              "roomNumber": model.user.roomNumber,
                                              "email": model.user.email,
                                              "hotelId": model.user.hotel.id,
                                              "hotelName": model.user.hotel.name],
                                       forUserAccount: "HotelStoreAccount")
                print("saved!")
            } catch {
                print("Unable to save data")
            }
            DispatchQueue.main.async {
                self.activityView.isHidden = false
                UserService().sendPromo(promo: self.promoTextField.text ?? "", name: self.nameTextField.text ?? "", email: self.emailTextField.text ?? "", hotel: self.hotelNameLabel.text ?? "", room: self.numberTextField.text ?? "")
                GetProductsService().getCategories()
                let vc = self.storyboard?.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setLabels()
        setTextFields()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func setView(){
        backgroundView.isHidden = true
        pickerView.isHidden = true
        self.navigationItem.hidesBackButton = true
        hotelNameLabel.text = model.hotels[0].name
        tickButton.isHidden = true
        activityView.layer.cornerRadius = 15
        activityView.isHidden = true
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setLabels(){
        russianLabel.text = "Я принимаю условия пользовательского соглашения и согласен на обработку персональных данных "
        englishLabel.text = "I accept the terms of the user agreement and agree to the processing of personal data"
    }
    
    private func setTextFields(){
        nameTextField.text = model.user.firstName
        emailTextField.text = model.user.email
        nameTextField.delegate = self
        emailTextField.delegate = self
        numberTextField.delegate = self
        promoTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(editEmail), for: .touchDown)
        numberTextField.addTarget(self, action: #selector(editNumber), for: .touchDown)
        if UIScreen.main.bounds.height < 700 {
            promoTextField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
            promoTextField.addTarget(self, action: #selector(editingEnd(_:)), for: .editingDidEnd)
        }
    }
    
    @objc func editingBegan(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func editingEnd(_ textField: UITextField) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func editEmail(textField: UITextField) {
        emailTextField.text = ""
        emailTextField.textColor = UIColor(named: "ColorTextField")
    }
    
    @objc func editNumber(textField: UITextField) {
        numberTextField.text = ""
        numberTextField.textColor = UIColor(named: "ColorTextField")
    }
}

extension DataPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.hotels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.hotels[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isPickerChanged = true
        selectedHotel = Hotel(name: model.hotels[row].name, id: model.hotels[row].id)
    }
}

extension DataPickerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
