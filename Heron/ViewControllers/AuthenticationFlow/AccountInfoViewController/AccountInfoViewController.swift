//
//  AccountInfoViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit
import Material

class AccountInfoViewController: BaseViewController,
                                 UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let viewModel   = AccountInfoViewModel()
    var isSign = true
    
    let firstNameTxt        = ErrorTextField()
    let lastNameTxt         = ErrorTextField()
    let genderTxt           = ErrorTextField()
    let dobTxt              = ErrorTextField()
    let emailTxt            = ErrorTextField()
    let phoneNumberCodeTxt  = ErrorTextField()
    let phoneNumberTxt      = ErrorTextField()
    
    var prevScreenPass      = ""
    var prevEmail           = ""
    
    private let datePicker  = UIDatePicker()
    private let genderPicker = UIPickerView()
    private let codePicker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
        
        let background = UIImageView(image: UIImage(named: "bg"))
        background.contentMode = .scaleAspectFit
        self.view.addSubview(background)
        background.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let backBtn = UIButton()
        backBtn.setBackgroundImage(UIImage.init(systemName: "chevron.backward"), for: .normal)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.width.equalTo(20)
        }
        
        let childVỉew = UIView()
        self.view.addSubview(childVỉew)
        childVỉew.layer.cornerRadius = 25
        childVỉew.backgroundColor = UIColor.init(hexString: "1890FF")?.withAlphaComponent(0.2)
        childVỉew.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        let accountInfoLabel = UILabel()
        accountInfoLabel.textAlignment = .center
        accountInfoLabel.text = "Account Info"
        accountInfoLabel.font = getFontSize(size: 24, weight: .bold)
        accountInfoLabel.textColor = kDefaultTextColor
        childVỉew.addSubview(accountInfoLabel)
        accountInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview()
        }
        
        let contentScrollView = UIScrollView()
        contentScrollView.showsVerticalScrollIndicator = false
        childVỉew.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(accountInfoLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        }
                
        firstNameTxt.placeholder = "First name *"
        firstNameTxt.dividerNormalHeight = 0.5
        firstNameTxt.dividerNormalColor = kPrimaryColor
        firstNameTxt.errorColor = .red
        firstNameTxt.textColor = kDefaultTextColor
        contentScrollView.addSubview(firstNameTxt)
        firstNameTxt.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).offset(-40)
        }
        
        lastNameTxt.placeholder = "Last Name *"
        lastNameTxt.dividerNormalHeight = 0.5
        lastNameTxt.dividerNormalColor = kPrimaryColor
        lastNameTxt.errorColor = .red
        lastNameTxt.textColor = kDefaultTextColor
        contentScrollView.addSubview(lastNameTxt)
        lastNameTxt.snp.makeConstraints { make in
            make.top.equalTo(firstNameTxt.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).offset(-40)
        }
        
        genderTxt.text = "Male"
        genderTxt.placeholder = "Gender *"
        genderTxt.dividerNormalHeight = 0.5
        genderTxt.dividerNormalColor = kPrimaryColor
        genderTxt.errorColor = .red
        genderTxt.textColor = kDefaultTextColor
        contentScrollView.addSubview(genderTxt)
        genderTxt.snp.makeConstraints { make in
            make.top.equalTo(lastNameTxt.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).offset(-40)
        }
        
        self.loadPickerView()
        
        dobTxt.placeholder = "Date of birth *"
        dobTxt.dividerNormalHeight = 0.5
        dobTxt.dividerNormalColor = kPrimaryColor
        dobTxt.errorColor = .red
        dobTxt.textColor = kDefaultTextColor
        dobTxt.inputView = self.datePicker
        contentScrollView.addSubview(dobTxt)
        dobTxt.snp.makeConstraints { make in
            make.top.equalTo(genderTxt.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).offset(-40)
        }
        
        emailTxt.text = self.prevEmail
        emailTxt.placeholder = "Email"
        emailTxt.dividerNormalHeight = 0.5
        emailTxt.dividerNormalColor = kPrimaryColor
        emailTxt.errorColor = .red
        emailTxt.textColor = kDefaultTextColor
        emailTxt.autocapitalizationType = .none
        emailTxt.isUserInteractionEnabled = false
        contentScrollView.addSubview(emailTxt)
        emailTxt.snp.makeConstraints { make in
            make.top.equalTo(dobTxt.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).offset(-40)
        }
                
        phoneNumberCodeTxt.text = "+01"
        phoneNumberCodeTxt.placeholder = "Phone Code *"
        phoneNumberCodeTxt.dividerNormalHeight = 0.5
        phoneNumberCodeTxt.dividerNormalColor = kPrimaryColor
        phoneNumberCodeTxt.errorColor = .red
        phoneNumberCodeTxt.textColor = kDefaultTextColor
        phoneNumberCodeTxt.keyboardType = .phonePad
        contentScrollView.addSubview(phoneNumberCodeTxt)
        phoneNumberCodeTxt.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(self.view).multipliedBy(0.3)
        }
        
        phoneNumberTxt.placeholder = "Phone number *"
        phoneNumberTxt.dividerNormalHeight = 0.5
        phoneNumberTxt.dividerNormalColor = kPrimaryColor
        phoneNumberTxt.errorColor = .red
        phoneNumberTxt.textColor = kDefaultTextColor
        phoneNumberTxt.keyboardType = .phonePad
        contentScrollView.addSubview(phoneNumberTxt)
        phoneNumberTxt.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(50)
            make.left.equalTo(phoneNumberCodeTxt.snp.right).offset(10)
            make.right.equalTo(self.view).offset(-20)
        }
        
        let createAccountBtn = UIButton()
        createAccountBtn.backgroundColor = kPrimaryColor
        createAccountBtn.layer.cornerRadius = 8
        createAccountBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        createAccountBtn.setTitle("Create", for: .normal)
        contentScrollView.addSubview(createAccountBtn)
        createAccountBtn.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTxt.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).offset(-40)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
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
        phoneNumberCodeTxt.inputView = codePicker
    }
    
    @objc private func doneDatePicker() {
        dobTxt.text = datePicker.date.toString(dateFormat: "MMM dd yyyy")
        self.view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        dobTxt.text = datePicker.date.toString(dateFormat: "MMM dd, yyyy")
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        userData.userDOB = Int(sender.date.timeIntervalSince1970)*1000
        viewModel.userData.accept(userData)
    }
    
    @objc func continueActionTapped(_ sender: Any) {
        
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        userData.userEmail = self.prevEmail
        userData.userName = self.prevEmail
        userData.password = self.prevScreenPass
        userData.passwordConfirm = self.prevScreenPass
        
        if (firstNameTxt.text ?? "").isEmpty {
            firstNameTxt.isErrorRevealed = true
            firstNameTxt.error = "This field can not be empty"
        }
        userData.userFirstName = firstNameTxt.text!.formatString()
        
        if (lastNameTxt.text ?? "").isEmpty {
            lastNameTxt.isErrorRevealed = true
            lastNameTxt.error = "This field can not be empty"
        }
        userData.userLastName = lastNameTxt.text!.formatString()
        
        if (genderTxt.text ?? "").isEmpty {
            genderTxt.isErrorRevealed = true
            genderTxt.error = "This field can not be empty"
        }
        
        if (dobTxt.text ?? "").isEmpty {
            dobTxt.isErrorRevealed = true
            dobTxt.error = "This field can not be empty"
        }
        
        userData.userEmail = emailTxt.text ?? ""
        
        if (phoneNumberTxt.text ?? "").isEmpty {
            phoneNumberTxt.isErrorRevealed = true
            phoneNumberTxt.error = "This field can not be empty"
        }
        userData.userPhoneNum = phoneNumberTxt.text!
        
        if firstNameTxt.isErrorRevealed ||
            lastNameTxt.isErrorRevealed ||
            genderTxt.isErrorRevealed ||
            dobTxt.isErrorRevealed ||
            phoneNumberTxt.isErrorRevealed {
            return
        }
        
        viewModel.userData.accept(userData)
        viewModel.signUp {
            let vc = SignInSuccessViewController()
            vc.centerDescInfo.text = "Congratulations,You have signed up successfully. Wish you have a nice experience."
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
                userData.userPhoneCode = "01"
            } else {
                phoneNumberCodeTxt.text = "+84"
                userData.userPhoneCode = "84"
            }
        }
        
        viewModel.userData.accept(userData)
    }
}
