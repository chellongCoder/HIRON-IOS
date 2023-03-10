//
//  AddUserAddressViewController.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import RxCocoa
import RxSwift
import Material
import PhoneNumberKit

class AddUserAddressViewController: PageScrollViewController,
                                    UITextFieldDelegate {
    
    private let firstNameTxt        = BoundedIconTextField()
    private let lastNameTxt         = BoundedIconTextField()
    private let phoneNumberTxt      = PhoneNumberTextField()
    private let emailTxt            = BoundedIconTextField()
    
    private let addressTxt          = BoundedIconTextField()
    private let countryTxt          = BoundedIconTextField()
    private let cityTxt             = BoundedIconTextField()
    private let postCodeTxt         = BoundedIconTextField()
    private let checkboxButton      = BoundedIconTextField()
    
    private let saveBtn             = UIButton()
    private let cancelBtn           = UIButton()
    private let defaultLabel        = UILabel()
    private let defaultBtn          = UISwitch()
    
    let viewModel                   = AddUserAddressViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.showBackBtn()
        
        viewModel.controller = self
        
        cancelBtn.layer.cornerRadius = 20
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(kPrimaryColor, for: .normal)
        cancelBtn.titleLabel?.font = getCustomFont(size: 14, name: .semiBold)
        cancelBtn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        saveBtn.backgroundColor = kPrimaryColor
        saveBtn.layer.cornerRadius = 20
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        saveBtn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        self.view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.bottom.equalTo(cancelBtn.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        defaultLabel.text = "Set as default"
        defaultLabel.textColor = kDarkColor
        defaultLabel.font = getCustomFont(size: 11, name: .light)
        defaultLabel.textAlignment = .left
        self.view.addSubview(defaultLabel)
        defaultLabel.snp.makeConstraints { make in
            make.bottom.equalTo(saveBtn.snp.top).offset(-15)
            make.left.equalToSuperview().offset(28)
            make.height.equalTo(15)
        }
        
        defaultBtn.isOn = viewModel.contact.value.isDefault
        defaultBtn.addTarget(self, action: #selector(setAsDefaultAddress), for: .valueChanged)
        self.view.addSubview(defaultBtn)
        defaultBtn.snp.makeConstraints { make in
            make.centerY.equalTo(defaultLabel)
            make.right.equalToSuperview().offset(-28)
        }
        
       let line1View = UIView()
        line1View.backgroundColor = kGrayColor
        self.view.addSubview(line1View)
        line1View.snp.makeConstraints { make in
            make.bottom.equalTo(defaultLabel.snp.top).offset(-20)
            make.width.equalToSuperview()
            make.height.equalTo(6)
        }
        
        pageScroll.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(line1View.snp.top).offset(-10)
        }
        
        let firstNameLabel = UILabel()
        firstNameLabel.text = "First Name *"
        firstNameLabel.font = getCustomFont(size: 11, name: .light)
        firstNameLabel.textColor = kDarkColor
        pageScroll.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(28)
        }
        
        firstNameTxt.delegate = self
        firstNameTxt.setPlaceHolderText("First Name")
        firstNameTxt.text = viewModel.contact.value.firstName
        firstNameTxt.textColor = kDefaultTextColor
        firstNameTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        firstNameTxt.rightAction = {
            self.clearValue(self.firstNameTxt)
        }
        self.pageScroll.addSubview(firstNameTxt)
        firstNameTxt.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(8)
            make.left.equalTo(firstNameLabel)
            make.right.equalTo(self.view.snp.centerX).offset(-10)
            make.height.equalTo(40)
        }

        let lastNameLabel = UILabel()
        lastNameLabel.text = "Last Name *"
        lastNameLabel.textColor = kDarkColor
        lastNameLabel.font = getCustomFont(size: 11, name: .light)
        pageScroll.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel)
            make.left.equalTo(self.view.snp.centerX).offset(4)
            make.right.equalToSuperview().offset(-28)
        }
        
        lastNameTxt.delegate = self
        lastNameTxt.setPlaceHolderText("Last Name")
        lastNameTxt.text = viewModel.contact.value.lastName
        lastNameTxt.textColor = kDefaultTextColor
        lastNameTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        lastNameTxt.rightAction = {
            self.clearValue(self.lastNameTxt)
        }
        self.pageScroll.addSubview(lastNameTxt)
        lastNameTxt.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-28)
            make.left.equalTo(lastNameLabel)
            make.height.equalTo(40)
        }
        
        let phoneLabel = UILabel()
        phoneLabel.text = "Phone Number *"
        phoneLabel.textColor = kDarkColor
        phoneLabel.font = getCustomFont(size: 11, name: .light)
        pageScroll.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
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

        phoneNumberTxt.text = viewModel.contact.value.phone
        self.pageScroll.addSubview(phoneNumberTxt)
        phoneNumberTxt.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(8)
            make.left.equalTo(phoneLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let warningLabel = UILabel()
        warningLabel.text = "Use to contact you with delivery info (mobile preferred)."
        warningLabel.font = getCustomFont(size: 11, name: .light)
        warningLabel.textColor = kDarkColor
        pageScroll.addSubview(warningLabel)
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTxt.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
                
        let emailLabel = UILabel()
        emailLabel.text = "Email *"
        emailLabel.textColor = kDarkColor
        emailLabel.font = getCustomFont(size: 11, name: .light)
        pageScroll.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(20)
            make.left.equalTo(firstNameLabel)
        }
        
        emailTxt.delegate = self
        emailTxt.setPlaceHolderText("Email")
        emailTxt.text = viewModel.contact.value.email
        emailTxt.textColor = kDefaultTextColor
        emailTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        emailTxt.rightAction = {
            self.clearValue(self.emailTxt)
        }
        self.pageScroll.addSubview(emailTxt)
        emailTxt.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.equalTo(firstNameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let lineView2 = UIView()
        lineView2.backgroundColor = kGrayColor
        pageScroll.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(6)
        }

        let addressLabel = UILabel()
        addressLabel.text = "Address *"
        addressLabel.textColor = kDarkColor
        addressLabel.font = getCustomFont(size: 11, name: .light)
        self.pageScroll.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(28)
        }

        addressTxt.delegate = self
        addressTxt.setPlaceHolderText("Address")
        addressTxt.text = viewModel.contact.value.address
        addressTxt.textColor = kDefaultTextColor
        addressTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        addressTxt.rightAction = {
            self.clearValue(self.addressTxt)
        }
        self.pageScroll.addSubview(addressTxt)
        addressTxt.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.left.equalTo(addressLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let countryLabel = UILabel()
        countryLabel.text = "Country *"
        countryLabel.font = getCustomFont(size: 11, name: .light)
        countryLabel.textColor = kDarkColor
        pageScroll.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTxt.snp.bottom).offset(20)
            make.left.equalTo(addressLabel)
        }

        countryTxt.delegate = self
        countryTxt.setPlaceHolderText("Country")
        countryTxt.text = viewModel.contact.value.country
        countryTxt.textColor = kDefaultTextColor
        countryTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        countryTxt.rightAction = {
            self.clearValue(self.countryTxt)
        }
        self.pageScroll.addSubview(countryTxt)
        countryTxt.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(8)
            make.left.equalTo(addressLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let cityLabel = UILabel()
        cityLabel.text = "City *"
        cityLabel.font = getCustomFont(size: 11, name: .light)
        cityLabel.textColor = kDarkColor
        pageScroll.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(countryTxt.snp.bottom).offset(20)
            make.left.equalTo(addressLabel)
        }

        cityTxt.delegate = self
        cityTxt.setPlaceHolderText("City")
        cityTxt.text = viewModel.contact.value.province
        cityTxt.textColor = kDefaultTextColor
        cityTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        cityTxt.rightAction = {
            self.clearValue(self.cityTxt)
        }
        self.pageScroll.addSubview(cityTxt)
        cityTxt.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.left.equalTo(addressLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let postCodeLabel = UILabel()
        postCodeLabel.text = "Zip Code *"
        postCodeLabel.font = getCustomFont(size: 11, name: .light)
        postCodeLabel.textColor = kDarkColor
        pageScroll.addSubview(postCodeLabel)
        postCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(cityTxt.snp.bottom).offset(20)
            make.left.equalTo(addressLabel)
        }

        postCodeTxt.delegate = self
        postCodeTxt.setPlaceHolderText("Zip Code")
        postCodeTxt.text = viewModel.contact.value.postalCode
        postCodeTxt.textColor = kDefaultTextColor
        postCodeTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        postCodeTxt.rightAction = {
            self.clearValue(self.postCodeTxt)
        }
        self.pageScroll.addSubview(postCodeTxt)
        postCodeTxt.snp.makeConstraints { make in
            make.top.equalTo(postCodeLabel.snp.bottom).offset(8)
            make.left.equalTo(addressLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    // MARK: - Buttons
    
    func clearValue(_ sender: BoundedIconTextField) {
        sender.text = ""
    }
    
    @objc private func setAsDefaultAddress() {
        var contact = viewModel.contact.value
        contact.isDefault = defaultBtn.isOn
        viewModel.contact.accept(contact)
    }
    
    @objc private func completeButtonTapped() {

        if (self.firstNameTxt.text ?? "").isEmpty {
            self.firstNameTxt.setError("This field can not be empty")
        } else {
            self.firstNameTxt.setError(nil)
        }

        if (self.lastNameTxt.text ?? "").isEmpty {
            self.lastNameTxt.setError("This field can not be empty")
        } else {
            self.lastNameTxt.setError(nil)
        }

        if self.phoneNumberTxt.isValidNumber {
            self.phoneNumberTxt.textColor = kDefaultTextColor
        } else {
            self.phoneNumberTxt.textColor = .red
        }

        if (self.emailTxt.text ?? "").isEmpty {
            self.emailTxt.setError("This field can not be empty")
        } else {
            self.emailTxt.setError(nil)
        }

        if (self.addressTxt.text ?? "").isEmpty {
            self.addressTxt.setError("This field can not be empty")
        } else {
            self.addressTxt.setError(nil)
        }

        if (self.countryTxt.text ?? "").isEmpty {
            self.countryTxt.setError("This field can not be empty")
        } else {
            self.countryTxt.setError(nil)
        }

        if (self.cityTxt.text ?? "").isEmpty {
            self.cityTxt.setError("This field can not be empty")
        } else {
            self.cityTxt.setError(nil)
        }

        if (self.postCodeTxt.text ?? "").isEmpty {
            self.postCodeTxt.setError("This field can not be empty")
        } else {
            self.postCodeTxt.setError(nil)
        }

        if self.viewModel.contact.value.isValidContact() {
            if viewModel.isUpdated {
                viewModel.updateAddress()
            } else {
                viewModel.createNewAddress()
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validateButton() {
        if self.firstNameTxt.text?.isEmpty ?? false {
            disableSaveBtn()
            return
        }
        if self.lastNameTxt.text?.isEmpty ?? false {
            disableSaveBtn()
            return
        }
        if !self.phoneNumberTxt.isValidNumber {
            disableSaveBtn()
            return
        }
        if self.emailTxt.text?.isEmpty ?? false {
            disableSaveBtn()
            return
        }
        if self.addressTxt.text?.isEmpty ?? false {
            disableSaveBtn()
            return
        }
        if self.countryTxt.text?.isEmpty ?? false {
            disableSaveBtn()
            return
        }
        if self.cityTxt.text?.isEmpty ?? false {
            disableSaveBtn()
            return
        }
        if self.postCodeTxt.text?.isEmpty ?? false {
            disableSaveBtn()
            return
        }
        saveBtn.isUserInteractionEnabled = true
        saveBtn.backgroundColor = kPrimaryColor
    }
    
    private func disableSaveBtn() {
        self.saveBtn.isUserInteractionEnabled = false
        self.saveBtn.backgroundColor = kDisableColor
    }
    
    // MARK: - Data
     override func bindingData() {

        viewModel.contact
            .subscribe { contactDataSource in
                guard let contact = contactDataSource.element else {return}
                if contact.isValidContact() {
                    self.saveBtn.backgroundColor = kPrimaryColor
                    self.saveBtn.isUserInteractionEnabled = true
                } else {
                    self.disableSaveBtn()
                }
            }
            .disposed(by: disposeBag)

         viewModel.animation
             .subscribe { animation in
                 if animation.element ?? false {
                     self.startLoadingAnimation()
                 } else {
                     self.endLoadingAnimation()
                 }
             }
             .disposed(by: disposeBag)

        firstNameTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if (firstNameTxt.text == "") {
                    firstNameTxt.setError("This field can not be empty")
                } else {
                    firstNameTxt.setError(nil)
                }
                var contact = viewModel.contact.value
                contact.firstName = firstNameTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)

        lastNameTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if (lastNameTxt.text == "") {
                    lastNameTxt.setError("This field can not be empty")
                } else {
                    lastNameTxt.setError(nil)
                }

                var contact = viewModel.contact.value
                contact.lastName = lastNameTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)

         phoneNumberTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if self.phoneNumberTxt.isValidNumber {
                    phoneNumberTxt.textColor = kDefaultTextColor
                } else {
                    phoneNumberTxt.textColor = .red
                }
                var contact = viewModel.contact.value
                contact.phone = phoneNumberTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)

        emailTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if (emailTxt.text == "") {
                    emailTxt.setError("This field can not be empty")
                } else if (!(emailTxt.text?.isValidEmail() ?? true)) {
                    emailTxt.setError("Email not valid")
                } else {
                    emailTxt.setError(nil)
                }
                var contact = viewModel.contact.value
                contact.email = emailTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)

        addressTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if (addressTxt.text == "") {
                    addressTxt.setError("This field can not be empty")
                } else {
                    addressTxt.setError(nil)
                }
                var contact = viewModel.contact.value
                contact.address = addressTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)

        countryTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if (countryTxt.text == "") {
                    countryTxt.setError("This field can not be empty")
                } else {
                    countryTxt.setError(nil)
                }

                var contact = viewModel.contact.value
                contact.country = countryTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)

        cityTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if (cityTxt.text == "") {
                    cityTxt.setError("This field can not be empty")
                } else {
                    cityTxt.setError(nil)
                }

                var contact = viewModel.contact.value
                contact.province = cityTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)

        postCodeTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in

                if (postCodeTxt.text == "") {
                    postCodeTxt.setError("This field can not be empty")
                } else {
                    postCodeTxt.setError(nil)
                }

                var contact = viewModel.contact.value
                contact.postalCode = postCodeTxt.text!
                viewModel.contact.accept(contact)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = kPrimaryColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = kLightGrayColor.cgColor
    }
}
