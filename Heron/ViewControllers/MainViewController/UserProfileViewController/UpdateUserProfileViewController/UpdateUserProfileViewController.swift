//
//  UpdateEHealthProfileViewController.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit
import RxSwift
import Material

class UpdateUserProfileViewController: PageScrollViewController ,
                                       UIPickerViewDelegate, UIPickerViewDataSource {

    private let viewModel   = UpdateUserProfileViewModel()
    let avatar              = UIImageView()
    let nameLabel           = UILabel()
    let dobLabel            = UILabel()
    let genderLabel         = UILabel()
    let phoneLabel          = UILabel()
    let emailLabel          = UILabel()
    
    let firstNameTxt        = ErrorTextField()
    let lastNameTxt         = ErrorTextField()
    let genderTxt           = ErrorTextField()
    let dobTxt              = ErrorTextField()
    let phoneNumberCodeTxt  = ErrorTextField()
    let phoneNumberTxt      = ErrorTextField()
    
    private let datePicker  = UIDatePicker()
    private let genderPicker = UIPickerView()
    private let codePicker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update User Profile"
        self.viewModel.controller = self
        
        self.showBackBtn()
        
        avatar.image = UIImage.init(named: "default-image")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.borderWidth = 1
        avatar.layer.cornerRadius = 8
        avatar.layer.borderColor = UIColor.gray.cgColor
        self.pageScroll.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.init(hexString: "F0F0F0")
        self.pageScroll.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
        }
        
        nameLabel.text = "Name: "
        nameLabel.textColor = kDefaultTextColor
        nameLabel.numberOfLines = 0
        nameLabel.textColor = UIColor.init(hexString: "444444")
        nameLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        dobLabel.text = "DOB: "
        dobLabel.textColor = kDefaultTextColor
        dobLabel.numberOfLines = 0
        dobLabel.textColor = UIColor.init(hexString: "444444")
        dobLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(dobLabel)
        dobLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        genderLabel.text = "Gender: "
        genderLabel.textColor = kDefaultTextColor
        genderLabel.numberOfLines = 0
        genderLabel.textColor = UIColor.init(hexString: "444444")
        genderLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(dobLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        phoneLabel.text = "Phone number: "
        phoneLabel.textColor = kDefaultTextColor
        phoneLabel.numberOfLines = 0
        phoneLabel.textColor = UIColor.init(hexString: "444444")
        phoneLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        emailLabel.text = "Email: "
        emailLabel.textColor = kDefaultTextColor
        emailLabel.numberOfLines = 0
        emailLabel.textColor = UIColor.init(hexString: "444444")
        emailLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        firstNameTxt.placeholder = "First Name *"
        firstNameTxt.dividerNormalHeight = 0.5
        firstNameTxt.dividerNormalColor = kPrimaryColor
        firstNameTxt.errorColor = .red
        firstNameTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(firstNameTxt)
        firstNameTxt.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        lastNameTxt.placeholder = "Last Name *"
        lastNameTxt.dividerNormalHeight = 0.5
        lastNameTxt.dividerNormalColor = kPrimaryColor
        lastNameTxt.errorColor = .red
        lastNameTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(lastNameTxt)
        lastNameTxt.snp.makeConstraints { make in
            make.top.equalTo(firstNameTxt.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        genderTxt.placeholder = "Gender"
        genderTxt.dividerNormalHeight = 0.5
        genderTxt.dividerNormalColor = kPrimaryColor
        genderTxt.errorColor = .red
        genderTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(genderTxt)
        genderTxt.snp.makeConstraints { make in
            make.top.equalTo(lastNameTxt.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        dobTxt.placeholder = "DOB"
        dobTxt.dividerNormalHeight = 0.5
        dobTxt.dividerNormalColor = kPrimaryColor
        dobTxt.errorColor = .red
        dobTxt.inputView = self.datePicker
        dobTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(dobTxt)
        dobTxt.snp.makeConstraints { make in
            make.top.equalTo(genderTxt.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        phoneNumberCodeTxt.text = "+84"
        phoneNumberCodeTxt.placeholder = "Phone Code *"
        phoneNumberCodeTxt.dividerNormalHeight = 0.5
        phoneNumberCodeTxt.dividerNormalColor = kPrimaryColor
        phoneNumberCodeTxt.errorColor = .red
        phoneNumberCodeTxt.textColor = kDefaultTextColor
        phoneNumberCodeTxt.keyboardType = .phonePad
        self.pageScroll.addSubview(phoneNumberCodeTxt)
        phoneNumberCodeTxt.snp.makeConstraints { make in
            make.top.equalTo(dobTxt.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(self.view).multipliedBy(0.3)
        }
        
        phoneNumberTxt.placeholder = "Phone number *"
        phoneNumberTxt.dividerNormalHeight = 0.5
        phoneNumberTxt.dividerNormalColor = kPrimaryColor
        phoneNumberTxt.errorColor = .red
        phoneNumberTxt.textColor = kDefaultTextColor
        phoneNumberTxt.keyboardType = .phonePad
        self.pageScroll.addSubview(phoneNumberTxt)
        phoneNumberTxt.snp.makeConstraints { make in
            make.top.equalTo(dobTxt.snp.bottom).offset(50)
            make.left.equalTo(phoneNumberCodeTxt.snp.right).offset(10)
            make.right.equalTo(self.view).offset(-20)
        }
        
        let completeBtn = UIButton()
        completeBtn.backgroundColor = kPrimaryColor
        completeBtn.layer.cornerRadius = 8
        completeBtn.setTitle("Complete", for: .normal)
        completeBtn.setTitleColor(.white, for: .normal)
        completeBtn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        self.pageScroll.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberCodeTxt.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        self.loadPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        viewModel.getUserProfile()
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
        dobTxt.text = datePicker.date.toString(dateFormat: "MMM dd, yyyy")
        self.view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        dobTxt.text = datePicker.date.toString(dateFormat: "MMM dd, yyyy")
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
        userData.userDOB = Int(sender.date.timeIntervalSince1970)*1000
        viewModel.userData.accept(userData)
    }
    
    // MARK: Binding Data
    override func bindingData() {
        viewModel.userData
            .observe(on: MainScheduler.instance)
            .subscribe { userDataSource in
                if let userData = userDataSource.element {
                    if let avatarImageURL = URL(string: userData?.userAvatarURL ?? "") {
                        self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
                    }
                    self.nameLabel.text = String(format: "Name: %@ %@", userData?.userFirstName ?? "", userData?.userLastName ?? "")
                    let dateDob = Date.init(timeIntervalSince1970: TimeInterval((userData?.userDOB ?? 0) / 1000))
                    self.dobLabel.text = String(format: "DOB: %@", dateDob.toString(dateFormat: "MMM dd, yyyy"))
                    self.genderLabel.text = String(format: "Gender: %@", (userData?.userGender == .male) ? "Male" : "Female")
                    self.phoneLabel.text = String(format: "Phone number: %@%@", userData?.userPhoneCode ?? "", userData?.userPhoneNum ?? "")
                    self.emailLabel.text = String(format: "Email : %@", userData?.userEmail ?? "")
                    
                    self.firstNameTxt.text = userData?.userFirstName
                    self.lastNameTxt.text = userData?.userLastName
                    self.genderTxt.text = (userData?.userGender == .male) ? "Male" : "Female"
                    self.dobTxt.text = dateDob.toString(dateFormat: "MMM dd, yyyy")
                    self.phoneNumberCodeTxt.text = userData?.userPhoneCode
                    self.phoneNumberTxt.text = userData?.userPhoneNum
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func completeButtonTapped() {
        
        let userData = viewModel.userData.value ?? UserDataSource.init(JSONString: "{}")!
                
        if (firstNameTxt.text ?? "").isEmpty {
            firstNameTxt.isErrorRevealed = true
            firstNameTxt.error = "This field can not be empty"
            return
        }
        userData.userFirstName = firstNameTxt.text!.formatString()
        
        if (lastNameTxt.text ?? "").isEmpty {
            lastNameTxt.isErrorRevealed = true
            lastNameTxt.error = "This field can not be empty"
            return
        }
        userData.userLastName = lastNameTxt.text!.formatString()
        
        if (genderTxt.text ?? "").isEmpty {
            genderTxt.isErrorRevealed = true
            genderTxt.error = "This field can not be empty"
            return
        }
        
        if (dobTxt.text ?? "").isEmpty {
            dobTxt.isErrorRevealed = true
            dobTxt.error = "This field can not be empty"
            return
        }
                
        if (phoneNumberTxt.text ?? "").isEmpty {
            phoneNumberTxt.isErrorRevealed = true
            phoneNumberTxt.error = "This field can not be empty"
            return
        }
        userData.userPhoneNum = phoneNumberTxt.text!
        
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
                userData.userPhoneCode = "01"
            } else {
                phoneNumberCodeTxt.text = "+84"
                userData.userPhoneCode = "84"
            }
        }
        
        viewModel.userData.accept(userData)
    }
}
