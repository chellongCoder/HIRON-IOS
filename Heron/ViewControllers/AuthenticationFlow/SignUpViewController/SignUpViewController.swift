//
//  AccountInfoViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit
import Material
import PhoneNumberKit

class SignUpViewController: BaseViewController,
                            UITextFieldDelegate {
    
    private let viewModel   = SignUpViewModel()
    var isSign = true
    
    let firstNameTxt        = BoundedIconTextField()
    let lastNameTxt         = BoundedIconTextField()
    let femaleBtn           = UIButton()
    let maleBtn             = UIButton()
    let dobTxt              = BoundedIconTextField()
    let emailTxt            = BoundedIconTextField()
    let passwordTxt         = BoundedIconTextField()
    let identityNumberTxt   = BoundedIconTextField()
    let phoneNumberTxt      = PhoneNumberTextField()
    
    var prevScreenPass      = ""
    var prevEmail           = ""
    
    private let datePicker  = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
        
        self.showBackBtn()
        
        let image = UIImageView()
        image.image = UIImage.init(named: "logo")
        self.navigationItem.titleView = image
//        self.view.addSubview(image)
        image.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
//            make.left.equalToSuperview().offset(16)
//            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(107)
        }
        
        let signUpLabel = UILabel()
        signUpLabel.textAlignment = .left
        signUpLabel.font = getCustomFont(size: 26, name: .bold)
        signUpLabel.textColor = kDefaultTextColor
        signUpLabel.text = "Sign up"
        self.view.addSubview(signUpLabel)
        signUpLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.equalToSuperview().offset(28)
        }
        
        let contentScrollView = UIScrollView()
        contentScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(signUpLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        }
        
        let firstNameLabel = UILabel()
        firstNameLabel.text = "First name"
        firstNameLabel.font = getCustomFont(size: 11, name: .light)
        firstNameLabel.textColor = kDarkColor
        firstNameLabel.textAlignment = .left
        contentScrollView.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(28)
        }
        
        firstNameTxt.delegate = self
        firstNameTxt.setPlaceHolderText(" First name *")
        firstNameTxt.textColor = kDefaultTextColor
        contentScrollView.addSubview(firstNameTxt)
        firstNameTxt.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-56)
        }
        
        let lastNameLabel = UILabel()
        lastNameLabel.text = "Last name *"
        lastNameLabel.font = getCustomFont(size: 11, name: .light)
        lastNameLabel.textColor = kDarkColor
        lastNameLabel.textAlignment = .left
        contentScrollView.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        lastNameTxt.delegate = self
        lastNameTxt.setPlaceHolderText(" Last name ")
        lastNameTxt.textColor = kDefaultTextColor
        contentScrollView.addSubview(lastNameTxt)
        lastNameTxt.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-56)
        }
        
        let genderLabel = UILabel()
        genderLabel.text = "Gender *"
        genderLabel.font = getCustomFont(size: 11, name: .light)
        genderLabel.textColor = kDarkColor
        genderLabel.textAlignment = .left
        contentScrollView.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameTxt.snp.bottom).offset(20)
            make.left.equalTo(lastNameTxt)
        }
        
        femaleBtn.setBackgroundImage(UIImage.init(named: "radio_active_btn"), for: .selected)
        femaleBtn.setBackgroundImage(UIImage.init(named: "radio_inactive_btn"), for: .normal)
        femaleBtn.addTarget(self, action: #selector(genderTapped(_:)), for: .touchUpInside)
        femaleBtn.isSelected = true
        contentScrollView.addSubview(femaleBtn)
        femaleBtn.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.height.width.equalTo(32)
        }
        
        let femaleLabel = UILabel()
        femaleLabel.text = "Female"
        femaleLabel.textColor = kDefaultTextColor
        femaleLabel.font = getCustomFont(size: 14, name: .semiBold)
        femaleLabel.textAlignment = .left
        contentScrollView.addSubview(femaleLabel)
        femaleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(femaleBtn)
            make.left.equalTo(femaleBtn.snp.right).offset(2)
            make.width.equalTo(80)
        }
        
        maleBtn.setBackgroundImage(UIImage.init(named: "radio_active_btn"), for: .selected)
        maleBtn.setBackgroundImage(UIImage.init(named: "radio_inactive_btn"), for: .normal)
        maleBtn.addTarget(self, action: #selector(genderTapped(_:)), for: .touchUpInside)
        maleBtn.isSelected = false
        contentScrollView.addSubview(maleBtn)
        maleBtn.snp.makeConstraints { make in
            make.centerY.equalTo(femaleBtn)
            make.left.equalTo(self.view.snp.centerX)
            make.height.width.equalTo(32)
        }
        
        let maleLabel = UILabel()
        maleLabel.text = "Male"
        maleLabel.textColor = kDefaultTextColor
        maleLabel.font = getCustomFont(size: 14, name: .semiBold)
        maleLabel.textAlignment = .left
        contentScrollView.addSubview(maleLabel)
        maleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(femaleBtn)
            make.left.equalTo(maleBtn.snp.right).offset(2)
        }
        
        self.loadPickerView()
        
        let dobLabel = UILabel()
        dobLabel.text = "Date of Birth"
        dobLabel.textColor = kDarkColor
        dobLabel.font = getCustomFont(size: 11, name: .light)
        dobLabel.textAlignment = .left
        contentScrollView.addSubview(dobLabel)
        dobLabel.snp.makeConstraints { make in
            make.top.equalTo(femaleBtn.snp.bottom).offset(20)
            make.left.equalTo(genderLabel)
        }
        
        dobTxt.delegate = self
        dobTxt.setPlaceHolderText("MM dd, yyyy")
        dobTxt.setRightIcon(UIImage.init(named: "calendar_icon"))
        dobTxt.textColor = kDefaultTextColor
        dobTxt.inputView = self.datePicker
        contentScrollView.addSubview(dobTxt)
        dobTxt.snp.makeConstraints { make in
            make.top.equalTo(dobLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(self.view).offset(-56)
        }
        
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = getCustomFont(size: 11, name: .light)
        emailLabel.textColor = kDarkColor
        emailLabel.textAlignment = .left
        contentScrollView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(dobTxt.snp.bottom).offset(20)
            make.left.equalTo(dobLabel)
        }
        
        emailTxt.delegate = self
        emailTxt.text = self.prevEmail
        emailTxt.setPlaceHolderText(" Email ")
        emailTxt.textColor = kDefaultTextColor
        emailTxt.autocapitalizationType = .none
        contentScrollView.addSubview(emailTxt)
        emailTxt.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-56)
        }
        
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.font = getCustomFont(size: 11, name: .light)
        passwordLabel.textColor = kDarkColor
        passwordLabel.textAlignment = .left
        contentScrollView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(20)
            make.left.equalTo(emailLabel)
        }
        
        passwordTxt.delegate = self
        passwordTxt.setPlaceHolderText("Password")
        passwordTxt.isSecureTextEntry = true
        passwordTxt.textColor = kDefaultTextColor
        passwordTxt.setRightIcon(UIImage.init(named: "show_pass_icon"))
        passwordTxt.rightAction = {
            self.passwordTxt.isSecureTextEntry = !self.passwordTxt.isSecureTextEntry
            if self.passwordTxt.isSecureTextEntry {
                self.passwordTxt.setRightIcon(UIImage.init(named: "show_pass_icon"))
            } else {
                self.passwordTxt.setRightIcon(UIImage.init(named: "hidden_pass_icon"))
            }
        }
        contentScrollView.addSubview(passwordTxt)
        passwordTxt.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let identityNumberLabel = UILabel()
        identityNumberLabel.text = "ID Number"
        identityNumberLabel.textColor = kDarkColor
        identityNumberLabel.font = getCustomFont(size: 11, name: .light)
        identityNumberLabel.textAlignment = .left
        contentScrollView.addSubview(identityNumberLabel)
        identityNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTxt.snp.bottom).offset(20)
            make.left.equalTo(emailLabel)
        }
        
        identityNumberTxt.delegate = self
        identityNumberTxt.setPlaceHolderText(" ID Number ")
        identityNumberTxt.textColor = kDefaultTextColor
        identityNumberTxt.autocapitalizationType = .none
        contentScrollView.addSubview(identityNumberTxt)
        identityNumberTxt.snp.makeConstraints { make in
            make.top.equalTo(identityNumberLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.text = "Phone number"
        phoneNumberLabel.font = getCustomFont(size: 11, name: .light)
        phoneNumberLabel.textColor = kDarkColor
        phoneNumberLabel.textAlignment = .left
        contentScrollView.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(identityNumberTxt.snp.bottom).offset(20)
            make.left.equalTo(identityNumberLabel)
        }
        
        phoneNumberTxt.delegate = self
        phoneNumberTxt.placeholder = " Phone number "
        phoneNumberTxt.textColor = kDefaultTextColor
        phoneNumberTxt.font = getCustomFont(size: 14, name: .semiBold)
        
        phoneNumberTxt.layer.borderWidth = 1
        phoneNumberTxt.layer.borderColor = kLightGrayColor.cgColor
        phoneNumberTxt.layer.cornerRadius = 6
        phoneNumberTxt.layer.masksToBounds = false
        
        phoneNumberTxt.withFlag = true
        phoneNumberTxt.withPrefix = true
        phoneNumberTxt.withExamplePlaceholder = true
        phoneNumberTxt.withDefaultPickerUI = true
        phoneNumberTxt.keyboardType = .phonePad
        contentScrollView.addSubview(phoneNumberTxt)
        phoneNumberTxt.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(8)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        let createAccountBtn = UIButton()
        createAccountBtn.backgroundColor = kPrimaryColor
        createAccountBtn.layer.cornerRadius = 20
        createAccountBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        createAccountBtn.setTitle("Create", for: .normal)
        createAccountBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        contentScrollView.addSubview(createAccountBtn)
        createAccountBtn.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTxt.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(false, animated: true)
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
    }
    
    @objc private func doneDatePicker() {
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        
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
    
    // MARK: - Buttons
    
    @objc private func genderTapped(_ sender: UIButton) {
        if sender == femaleBtn {
            sender.isSelected = !sender.isSelected
            self.maleBtn.isSelected = !self.femaleBtn.isSelected
        } else if sender == maleBtn {
            sender.isSelected = !sender.isSelected
            self.femaleBtn.isSelected = !self.maleBtn.isSelected
        }
    }
    
    @objc func continueActionTapped(_ sender: Any) {

        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        userData.userEmail = self.prevEmail
        userData.userName = self.prevEmail
        userData.password = self.prevScreenPass
        userData.passwordConfirm = self.prevScreenPass

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

        if (femaleBtn.isSelected == true) {
            userData.userGender = .female
        } else {
            userData.userGender = .male
        }

        if (dobTxt.text ?? "").isEmpty {
            dobTxt.setError("This field can not be empty")
        } else {
            dobTxt.setError(nil)
        }

        userData.userEmail = emailTxt.text ?? ""

        if (identityNumberTxt.text ?? "").isEmpty {
            identityNumberTxt.setError("This field can not be empty")
        } else {
            identityNumberTxt.setError(nil)
        }
        userData.identityNum = identityNumberTxt.text ?? ""
        
        if !(emailTxt.text ?? "").isValidEmail() {
            emailTxt.setError("Email is not valid")
        } else {
            emailTxt.setError(nil)
        }
        userData.userEmail = emailTxt.text ?? ""
        
        if (passwordTxt.text ?? "").isEmpty {
            passwordTxt.setError("This field can not be empty")
        } else {
            passwordTxt.setError(nil)
        }
        userData.password = passwordTxt.text ?? ""

        if phoneNumberTxt.isValidNumber {
            phoneNumberTxt.textColor = kDefaultTextColor
        } else {
            phoneNumberTxt.textColor = .red
        }
        userData.userPhoneNum = phoneNumberTxt.text!

        if (firstNameTxt.text?.isEmpty ?? true) ||
            lastNameTxt.text?.isEmpty ?? true ||
            dobTxt.text?.isEmpty ?? true ||
            identityNumberTxt.text?.isEmpty ?? true ||
            !phoneNumberTxt.isValidNumber {
            return
        }

        viewModel.userData.accept(userData)
        viewModel.signUp {
            let vc = SignInSuccessViewController()
            vc.centerDesc.text = "Sign-up Success!"
            vc.centerDescInfo.text = "Congratulations! You have signed up successfully.\nWe wish you the best experience using our app! Have a good day!"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = kPrimaryColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = kLightGrayColor.cgColor
    }
}
