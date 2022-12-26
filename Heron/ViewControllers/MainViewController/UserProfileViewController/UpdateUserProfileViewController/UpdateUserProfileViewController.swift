//
//  UpdateEHealthProfileViewController.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit
import RxSwift
import Material
import PhoneNumberKit

class UpdateUserProfileViewController: PageScrollViewController ,
                                       UIPickerViewDelegate, UIPickerViewDataSource,
                                       UITextFieldDelegate {

    private let viewModel   = UpdateUserProfileViewModel()
    
    let firstNameTxt        = BoundedIconTextField()
    let lastNameTxt         = BoundedIconTextField()
    let genderTxt           = BoundedIconTextField()
    let dobTxt              = BoundedIconTextField()
    let phoneNumberCodeTxt  = BoundedIconTextField()
    let phoneNumberTxt      = PhoneNumberTextField()
    let emailTxt            = BoundedIconTextField()
    let userIDText          = BoundedIconTextField()
    
    private let datePicker  = UIDatePicker()
    private let genderPicker = UIPickerView()
    private let codePicker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update User Profile"
        self.viewModel.controller = self
        
        self.showBackBtn()
        
        let completeBtn = UIButton()
        completeBtn.backgroundColor = kPrimaryColor
        completeBtn.layer.cornerRadius = 20
        completeBtn.setTitle("Complete", for: .normal)
        completeBtn.setTitleColor(.white, for: .normal)
        completeBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        completeBtn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        self.view.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        pageScroll.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(completeBtn.snp.top).offset(-10)
        }
        
        let firstNameLabel      = UILabel()
        firstNameLabel.text = "First Name *"
        firstNameLabel.font = getCustomFont(size: 11, name: .light)
        firstNameLabel.textColor = kDarkColor
        firstNameLabel.textAlignment = .left
        self.pageScroll.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.left.equalToSuperview().offset(28)
        }
        
        firstNameTxt.setPlaceHolderText("First Name")
        firstNameTxt.delegate = self
        firstNameTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        firstNameTxt.rightAction = {
            self.righTextFieldButtonTapped(self.firstNameTxt)
        }
        self.pageScroll.addSubview(firstNameTxt)
        firstNameTxt.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(8)
            make.left.equalTo(firstNameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let lastNameLabel       = UILabel()
        lastNameLabel.text = "Last Name *"
        lastNameLabel.font = getCustomFont(size: 11, name: .light)
        lastNameLabel.textColor = kDarkColor
        lastNameLabel.textAlignment = .left
        self.pageScroll.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        lastNameTxt.setPlaceHolderText("Last Name")
        lastNameTxt.delegate = self
        lastNameTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        lastNameTxt.rightAction = {
            self.righTextFieldButtonTapped(self.lastNameTxt)
        }
        self.pageScroll.addSubview(lastNameTxt)
        lastNameTxt.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(8)
            make.left.equalTo(firstNameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let dobLabel            = UILabel()
        dobLabel.text = "DOB *"
        dobLabel.font = getCustomFont(size: 11, name: .light)
        dobLabel.textColor = kDarkColor
        dobLabel.textAlignment = .left
        self.pageScroll.addSubview(dobLabel)
        dobLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        dobTxt.setPlaceHolderText("DOB")
        dobTxt.inputView = self.datePicker
        dobTxt.setRightIcon(UIImage.init(named: "calendar_icon"))
        dobTxt.rightAction = {
            self.righTextFieldButtonTapped(self.dobTxt)
        }
        self.pageScroll.addSubview(dobTxt)
        dobTxt.snp.makeConstraints { make in
            make.top.equalTo(dobLabel.snp.bottom).offset(8)
            make.left.equalTo(firstNameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let genderLabel         = UILabel()
        genderLabel.text = "Gender *"
        genderLabel.font = getCustomFont(size: 11, name: .light)
        genderLabel.textColor = kDarkColor
        genderLabel.textAlignment = .left
        self.pageScroll.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(dobTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        genderTxt.setPlaceHolderText("Gender")
        genderTxt.rightAction = {
            self.righTextFieldButtonTapped(self.genderTxt)
        }
        genderTxt.setRightIcon(UIImage.init(named: "down_icon"))
        self.pageScroll.addSubview(genderTxt)
        genderTxt.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.left.equalTo(firstNameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let phoneNumberLabel    = UILabel()
        phoneNumberLabel.text = "Phone number *"
        phoneNumberLabel.font = getCustomFont(size: 11, name: .light)
        phoneNumberLabel.textColor = kDarkColor
        phoneNumberLabel.textAlignment = .left
        self.pageScroll.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(genderTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        phoneNumberTxt.placeholder = " Phone number "
        phoneNumberTxt.textColor = kCustomTextColor
        phoneNumberTxt.font = getCustomFont(size: 14, name: .semiBold)
        
        phoneNumberTxt.layer.borderWidth = 1
        phoneNumberTxt.layer.borderColor = kLightGrayColor.cgColor
        phoneNumberTxt.layer.cornerRadius = 6
        phoneNumberTxt.layer.masksToBounds = false
        
        phoneNumberTxt.withFlag = true
        phoneNumberTxt.withPrefix = true
        phoneNumberTxt.withExamplePlaceholder = true
        phoneNumberTxt.withDefaultPickerUI = true
        phoneNumberTxt.isUserInteractionEnabled = false
        phoneNumberTxt.keyboardType = .phonePad
        self.pageScroll.addSubview(phoneNumberTxt)
        phoneNumberTxt.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(8)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        let emailLabel          = UILabel()
        emailLabel.text = "Email *"
        emailLabel.font = getCustomFont(size: 11, name: .light)
        emailLabel.textColor = kDarkColor
        emailLabel.textAlignment = .left
        self.pageScroll.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        emailTxt.delegate = self
//        emailTxt.text = self.prevEmail
        emailTxt.setPlaceHolderText(" Email ")
        emailTxt.textColor = kCustomTextColor
        emailTxt.isUserInteractionEnabled = false
        emailTxt.autocapitalizationType = .none
        self.pageScroll.addSubview(emailTxt)
        emailTxt.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-56)
        }
        
        let userIDLabel         = UILabel()
        userIDLabel.text = "ID *"
        userIDLabel.font = getCustomFont(size: 11, name: .light)
        userIDLabel.textColor = kDarkColor
        userIDLabel.textAlignment = .left
        self.pageScroll.addSubview(userIDLabel)
        userIDLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        userIDText.setPlaceHolderText("ID")
        userIDText.textColor = kCustomTextColor
        userIDText.isUserInteractionEnabled = false
        userIDText.delegate = self
        self.pageScroll.addSubview(userIDText)
        userIDText.snp.makeConstraints { make in
            make.top.equalTo(userIDLabel.snp.bottom).offset(8)
            make.left.equalTo(firstNameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
        }
        
//        addressLabel.text = "Address *"
//        addressLabel.font = getCustomFont(size: 11, name: .light)
//        addressLabel.textColor = kDarkColor
//        addressLabel.textAlignment = .left
//        self.pageScroll.addSubview(addressLabel)
//        addressLabel.snp.makeConstraints { make in
//            make.top.equalTo(userIDText.snp.bottom).offset(20)
//            make.left.equalTo(firstNameLabel)
//        }
        
//        addressTxt.setPlaceHolderText("Address")
//        addressTxt.delegate = self
//        addressTxt.rightAction = {
//            self.righTextFieldButtonTapped(self.addressTxt)
//        }
//        addressTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
//        self.pageScroll.addSubview(addressTxt)
//        addressTxt.snp.makeConstraints { make in
//            make.top.equalTo(addressLabel.snp.bottom).offset(8)
//            make.left.equalTo(firstNameLabel)
//            make.width.equalToSuperview().offset(-56)
//            make.height.equalTo(40)
//            make.bottom.lessThanOrEqualToSuperview().offset(-10)
//        }
//
//
        
        self.loadPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        viewModel.getUserProfile()
    }
    
    // MARK: - Buttons
    
    private func righTextFieldButtonTapped(_ sender: BoundedIconTextField) {
        if sender == dobTxt {
            dobTxt.becomeFirstResponder()
        } else if sender == genderTxt {
            genderTxt.becomeFirstResponder()
        } else {
            sender.text = ""
        }
    }
    
    private func loadPickerView() {
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.day = -1
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.datePickerMode = .date
//        datePicker.locale = .current
        datePicker.timeZone = TimeZone.init(identifier: "UTC")
        datePicker.maximumDate = maxDate
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }

        let doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done",
                                   style: .done,
                                   target: self,
                                   action: #selector(doneDatePicker))

        doneToolbar.setItems([flexSpace, done], animated: true)
        doneToolbar.sizeToFit()

        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dobTxt.inputView = datePicker
        dobTxt.inputAccessoryView = doneToolbar
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTxt.inputView = genderPicker
        
        codePicker.dataSource = self
        codePicker.delegate = self
        if phoneNumberCodeTxt.text == "+84" {
            codePicker.selectRow(1, inComponent: 0, animated: false)
        }
        phoneNumberCodeTxt.inputView = codePicker
    }
    
    @objc private func doneDatePicker() {
        
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        
        if genderTxt.text == "Male" {
            userData.userGender = .male
        } else {
            userData.userGender = .female
        }
        
        dobTxt.text = datePicker.date.toString(dateFormat: "MMM dd, yyyy")
        userData.userDOB = Int(datePicker.date.timeIntervalSince1970)*1000
        viewModel.userData.accept(userData)
        
        self.view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        dobTxt.text = datePicker.date.toString(dateFormat: "MMM dd, yyyy")
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        userData.userDOB = Int(sender.date.timeIntervalSince1970)*1000
        viewModel.userData.accept(userData)
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        viewModel.userData
            .observe(on: MainScheduler.instance)
            .subscribe { userDataSource in
                if let userData = userDataSource.element {
//                    if let avatarImageURL = URL(string: userData?.userAvatarURL ?? "") {
                        //self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
//                    }
                    let dateDob = Date.init(timeIntervalSince1970: TimeInterval((userData?.userDOB ?? 0) / 1000))
                    self.datePicker.setDate(dateDob, animated: true)
                    
                    self.firstNameTxt.text = userData?.userFirstName
                    self.lastNameTxt.text = userData?.userLastName
                    
                    if userData?.userGender == .male {
                        self.genderTxt.text = "Male"
                        self.genderPicker.selectRow(0, inComponent: 0, animated: false)
                    } else {
                        self.genderTxt.text = "Female"
                        self.genderPicker.selectRow(1, inComponent: 0, animated: false)
                    }
                    
                    self.genderTxt.text = (userData?.userGender == .male) ? "Male" : "Female"
                    self.dobTxt.text = dateDob.toString(dateFormat: "MMM dd, yyyy")
                    self.phoneNumberCodeTxt.text = userData?.userPhoneCode
                    self.phoneNumberTxt.text = userData?.userPhoneNum
                    self.emailTxt.text = userData?.userEmail
                    self.userIDText.text = userData?.identityNum
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func completeButtonTapped() {
        
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
                
        if (firstNameTxt.text ?? "").isEmpty {
            firstNameTxt.setError("This field can not be empty")
        } else {
            firstNameTxt.setError(nil)
        }
        userData.userFirstName = firstNameTxt.text!.formatString()
        
        if (lastNameTxt.text ?? "").isEmpty {
            lastNameTxt.setError("This field can not be empty")
        } else {
            lastNameTxt.setError(nil)
        }
        userData.userLastName = lastNameTxt.text!.formatString()
        
        if (genderTxt.text ?? "").isEmpty {
            genderTxt.setError("This field can not be empty")
        } else {
            genderTxt.setError(nil)
        }
        
        if (dobTxt.text ?? "").isEmpty {
            dobTxt.setError("This field can not be empty")
        } else {
            dobTxt.setError(nil)
        }
                
        if phoneNumberTxt.isValidNumber {
            phoneNumberTxt.textColor = kDefaultTextColor
        } else {
            phoneNumberTxt.textColor = .red
        }
        userData.userPhoneNum = phoneNumberTxt.text!
        
        if firstNameTxt.text?.isEmpty ?? false ||
            lastNameTxt.text?.isEmpty ?? false ||
            genderTxt.text?.isEmpty ?? false ||
            dobTxt.text?.isEmpty ?? false ||
            !phoneNumberTxt.isValidNumber {
            return
        }
        
        viewModel.updateUserProfile(userData)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPicker {
            if row == 0 {
                return "Male"
            }
            return "Female"
        } else {
            if row == 0 {
                return "+01"
            }
            return "+84"
        }
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        
        if pickerView == genderPicker {
            if row == 0 {
                genderTxt.text = "Male"
                userData.userGender = .male
            } else {
                genderTxt.text = "Female"
                userData.userGender = .female
            }
        } else {
            if row == 0 {
                phoneNumberCodeTxt.text = "+01"
                userData.userPhoneCode = "+01"
            } else {
                phoneNumberCodeTxt.text = "+84"
                userData.userPhoneCode = "+84"
            }
        }
        
        viewModel.userData.accept(userData)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = kPrimaryColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = kLightGrayColor.cgColor
        
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        if textField == firstNameTxt {
            userData.userFirstName = firstNameTxt.text ?? ""
        } else if textField == lastNameTxt {
            userData.userLastName = lastNameTxt.text ?? ""
        }
        
        viewModel.userData.accept(userData)
    }
}
