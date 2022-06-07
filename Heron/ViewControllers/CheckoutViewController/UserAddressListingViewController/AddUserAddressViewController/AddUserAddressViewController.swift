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

class AddUserAddressViewController: BaseViewController {
    
    private let firstNameTxt        = ErrorTextField()
    private let lastNameTxt         = ErrorTextField()
    private let phoneTxt            = ErrorTextField()
    private let emailTxt            = ErrorTextField()
    
    private let addressTxt          = ErrorTextField()
    private let countryTxt          = ErrorTextField()
    private let cityTxt             = ErrorTextField()
    private let postCodeTxt         = ErrorTextField()
    private let checkboxButton      = UIButton()
    
    private let completeBtn         = UIButton()
    
    let viewModel                   = AddUserAddressViewModel()
    private let disposeBage         = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Add new address"
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
        viewModel.controller = self
        
        let contactTitle = UILabel()
        contactTitle.text = "Contacts"
        contactTitle.textColor = kDefaultTextColor
        contactTitle.font = getFontSize(size: 16, weight: .medium)
        self.pageScroll.addSubview(contactTitle)
        contactTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        firstNameTxt.placeholder = "First Name"
        firstNameTxt.text = viewModel.contact.value.firstName
        firstNameTxt.dividerNormalHeight = 0.5
        firstNameTxt.dividerNormalColor = kPrimaryColor
        firstNameTxt.errorColor = .red
        firstNameTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(firstNameTxt)
        firstNameTxt.snp.makeConstraints { make in
            make.top.equalTo(contactTitle.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-30)
            make.height.equalTo(50)
        }
        
        lastNameTxt.placeholder = "Last Name"
        lastNameTxt.text = viewModel.contact.value.lastName
        lastNameTxt.dividerNormalHeight = 0.5
        lastNameTxt.dividerNormalColor = kPrimaryColor
        lastNameTxt.errorColor = .red
        lastNameTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(lastNameTxt)
        lastNameTxt.snp.makeConstraints { make in
            make.top.equalTo(contactTitle.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-30)
            make.height.equalTo(50)
        }
        
        phoneTxt.placeholder = "Phone Number"
        phoneTxt.text = viewModel.contact.value.phone
        phoneTxt.dividerNormalHeight = 0.5
        phoneTxt.dividerNormalColor = kPrimaryColor
        phoneTxt.errorColor = .red
        phoneTxt.textColor = kDefaultTextColor
        phoneTxt.keyboardType = .numberPad
        self.pageScroll.addSubview(phoneTxt)
        phoneTxt.snp.makeConstraints { make in
            make.top.equalTo(firstNameTxt.snp.bottom).offset(40)
            make.left.equalTo(firstNameTxt)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        emailTxt.placeholder = "Email"
        emailTxt.text = viewModel.contact.value.email
        emailTxt.dividerNormalHeight = 0.5
        emailTxt.dividerNormalColor = kPrimaryColor
        emailTxt.errorColor = .red
        emailTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(emailTxt)
        emailTxt.snp.makeConstraints { make in
            make.top.equalTo(phoneTxt.snp.bottom).offset(40)
            make.left.equalTo(firstNameTxt)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        let addressTitle = UILabel()
        addressTitle.text = "Address"
        addressTitle.textColor = kDefaultTextColor
        addressTitle.font = getFontSize(size: 16, weight: .medium)
        self.pageScroll.addSubview(addressTitle)
        addressTitle.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        addressTxt.placeholder = "Address"
        addressTxt.text = viewModel.contact.value.address
        addressTxt.dividerNormalHeight = 0.5
        addressTxt.dividerNormalColor = kPrimaryColor
        addressTxt.errorColor = .red
        addressTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(addressTxt)
        addressTxt.snp.makeConstraints { make in
            make.top.equalTo(addressTitle.snp.bottom).offset(20)
            make.left.equalTo(firstNameTxt)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        countryTxt.placeholder = "Country"
        countryTxt.text = viewModel.contact.value.country
        countryTxt.dividerNormalHeight = 0.5
        countryTxt.dividerNormalColor = kPrimaryColor
        countryTxt.errorColor = .red
        countryTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(countryTxt)
        countryTxt.snp.makeConstraints { make in
            make.top.equalTo(addressTxt.snp.bottom).offset(40)
            make.left.equalTo(firstNameTxt)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        cityTxt.placeholder = "City"
        cityTxt.text = viewModel.contact.value.province
        cityTxt.dividerNormalHeight = 0.5
        cityTxt.dividerNormalColor = kPrimaryColor
        cityTxt.errorColor = .red
        cityTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(cityTxt)
        cityTxt.snp.makeConstraints { make in
            make.top.equalTo(countryTxt.snp.bottom).offset(40)
            make.left.equalTo(firstNameTxt)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        postCodeTxt.placeholder = "Post Code"
        postCodeTxt.text = viewModel.contact.value.postalCode
        postCodeTxt.dividerNormalHeight = 0.5
        postCodeTxt.dividerNormalColor = kPrimaryColor
        postCodeTxt.errorColor = .red
        postCodeTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(postCodeTxt)
        postCodeTxt.snp.makeConstraints { make in
            make.top.equalTo(cityTxt.snp.bottom).offset(40)
            make.left.equalTo(firstNameTxt)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        checkboxButton.tintColor = kPrimaryColor
        checkboxButton.isSelected = viewModel.contact.value.isDefault
        checkboxButton.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkboxButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.imageView?.contentMode = .scaleAspectFit
        checkboxButton.addTarget(self, action: #selector(setAsDefaultAddress), for:.touchUpInside)
        self.pageScroll.addSubview(checkboxButton)
        checkboxButton.snp.makeConstraints { make in
            make.top.equalTo(postCodeTxt.snp.bottom).offset(10)
            make.left.equalTo(firstNameTxt)
            make.width.height.equalTo(35)
        }
        
        let checkboxTitle = UILabel()
        checkboxTitle.text = "using as default address"
        checkboxTitle.textColor = kPrimaryColor
        checkboxTitle.font = getFontSize(size: 14, weight: .regular)
        self.pageScroll.addSubview(checkboxTitle)
        checkboxTitle.snp.makeConstraints { make in
            make.centerY.equalTo(checkboxButton)
            make.left.equalTo(checkboxButton.snp.right).offset(5)
            make.right.equalTo(postCodeTxt)
            make.bottom.lessThanOrEqualToSuperview().offset(-90)
        }
        
        completeBtn.backgroundColor = kPrimaryColor
        completeBtn.layer.cornerRadius = 8
        completeBtn.setTitle("Complete", for: .normal)
        completeBtn.setTitleColor(.white, for: .normal)
        completeBtn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        self.view.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        self.bindingData()
    }
    
    //MARK: - Buttons
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func setAsDefaultAddress() {
        checkboxButton.isSelected = !checkboxButton.isSelected
        
        var contact = viewModel.contact.value
        contact.isDefault = checkboxButton.isSelected
        viewModel.contact.accept(contact)
    }
    
    @objc private func completeButtonTapped() {
        if viewModel.isUpdated {
            viewModel.updateAddress()
        } else {
            viewModel.createNewAddress()
        }
    }
    
    //MARK: - Data
    private func bindingData() {
        
        viewModel.contact
            .subscribe { contactDataSource in
                guard let contact = contactDataSource.element else {return}
                if contact.isValidContact() {
                    self.completeBtn.backgroundColor = kPrimaryColor
                    self.completeBtn.isUserInteractionEnabled = true
                } else {
                    self.completeBtn.backgroundColor = kDisableColor
                    self.completeBtn.isUserInteractionEnabled = false
                }
            }
            .disposed(by: disposeBage)

        
        firstNameTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (firstNameTxt.text == "") {
                    firstNameTxt.error = "This field can not be empty"
                    firstNameTxt.isErrorRevealed = true
                } else {
                    firstNameTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.firstName = firstNameTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
        
        lastNameTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (lastNameTxt.text == "") {
                    lastNameTxt.error = "This field can not be empty"
                    lastNameTxt.isErrorRevealed = true
                } else {
                    lastNameTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.lastName = lastNameTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
        
        phoneTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (phoneTxt.text == "") {
                    phoneTxt.error = "This field can not be empty"
                    phoneTxt.isErrorRevealed = true
                } else {
                    phoneTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.phone = phoneTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
        
        emailTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (emailTxt.text == "") {
                    emailTxt.error = "This field can not be empty"
                    emailTxt.isErrorRevealed = true
                } else if (!(emailTxt.text?.isValidEmail() ?? true)) {
                    emailTxt.error = "Email not valid"
                    emailTxt.isErrorRevealed = true
                }else {
                    emailTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.email = emailTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
        
        addressTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (addressTxt.text == "") {
                    addressTxt.error = "This field can not be empty"
                    addressTxt.isErrorRevealed = true
                } else {
                    addressTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.address = addressTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
        
        countryTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (countryTxt.text == "") {
                    countryTxt.error = "This field can not be empty"
                    countryTxt.isErrorRevealed = true
                } else {
                    countryTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.country = countryTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
        
        cityTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (cityTxt.text == "") {
                    cityTxt.error = "This field can not be empty"
                    cityTxt.isErrorRevealed = true
                } else {
                    cityTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.province = cityTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
        
        postCodeTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                if (postCodeTxt.text == "") {
                    postCodeTxt.error = "This field can not be empty"
                    postCodeTxt.isErrorRevealed = true
                } else {
                    postCodeTxt.isErrorRevealed = false
                    
                    var contact = viewModel.contact.value
                    contact.postalCode = postCodeTxt.text!
                    viewModel.contact.accept(contact)
                }
            })
            .disposed(by: disposeBage)
    }
}
