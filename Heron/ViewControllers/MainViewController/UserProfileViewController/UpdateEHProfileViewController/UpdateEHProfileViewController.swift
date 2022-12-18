//
//  UpdateEHProfileViewController.swift
//  Heron
//
//  Created by Luu Luc on 05/09/2022.
//

import UIKit
import RxSwift
import Material
import PhoneNumberKit

class UpdateEHProfileViewController: PageScrollViewController,
                                     UITextFieldDelegate {
    private let viewModel   = UpdateEHProfileViewModel()
    
    private let nameTxt         = BoundedIconTextField()
    private let dobTxt          = BoundedIconTextField()
    private let genderTxt       = BoundedIconTextField()
    private let phoneNumberTxt  = PhoneNumberTextField()
    private let emailTxt        = BoundedIconTextField()
    private let addressTxt      = BoundedIconTextField()
    private let countryTxt      = BoundedIconTextField()
    private let regionTxt       = BoundedIconTextField()
    private let provinceTxt     = BoundedIconTextField()
    private let districtTxt     = BoundedIconTextField()
    private let wardTxt         = BoundedIconTextField()
    private let postCodeTxt     = BoundedIconTextField()
    private let professionTxt   = BoundedIconTextField()

    let updateBtn           = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update E-Health Profile"
        self.viewModel.controller = self
        
        self.showBackBtn()
        
        updateBtn.backgroundColor = kPrimaryColor
        updateBtn.layer.cornerRadius = 20
        updateBtn.setTitle("Complete", for: .normal)
        updateBtn.setTitleColor(.white, for: .normal)
        updateBtn.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        self.view.addSubview(updateBtn)
        updateBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        pageScroll.snp.remakeConstraints { (make) in
            make.left.top.right.centerX.equalToSuperview()
            make.bottom.equalTo(updateBtn.snp.top).offset(-10)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Name: "
        nameLabel.textColor = kDarkColor
        nameLabel.font = getCustomFont(size: 11, name: .light)
        nameLabel.textAlignment = .left
        self.pageScroll.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(28)
        }
        
        nameTxt.setPlaceHolderText("Name")
        nameTxt.isUserInteractionEnabled = false
        nameTxt.textColor = kCustomTextColor
        self.pageScroll.addSubview(nameTxt)
        nameTxt.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let dobLabel = UILabel()
        dobLabel.text = "DOB: "
        dobLabel.textColor = kDarkColor
        dobLabel.font = getCustomFont(size: 11, name: .light)
        dobLabel.textAlignment = .left
        self.pageScroll.addSubview(dobLabel)
        dobLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        dobTxt.setPlaceHolderText("DOB")
        dobTxt.isUserInteractionEnabled = false
        dobTxt.textColor = kCustomTextColor
        self.pageScroll.addSubview(dobTxt)
        dobTxt.snp.makeConstraints { make in
            make.top.equalTo(dobLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let genderLabel = UILabel()
        genderLabel.text = "Gender: "
        genderLabel.textColor = kDarkColor
        genderLabel.font = getCustomFont(size: 11, name: .light)
        genderLabel.textAlignment = .left
        self.pageScroll.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(dobTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        genderTxt.setPlaceHolderText("Gender")
        genderTxt.textColor = kCustomTextColor
        genderTxt.isUserInteractionEnabled = false
        self.pageScroll.addSubview(genderTxt)
        genderTxt.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let phoneLabel = UILabel()
        phoneLabel.text = "Phone number: "
        phoneLabel.textColor = kDarkColor
        phoneLabel.font = getCustomFont(size: 11, name: .light)
        phoneLabel.textAlignment = .left
        self.pageScroll.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(genderTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
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
            make.top.equalTo(phoneLabel.snp.bottom).offset(8)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        let emailLabel = UILabel()
        emailLabel.text = "Email: "
        emailLabel.textColor = kDarkColor
        emailLabel.font = getCustomFont(size: 11, name: .light)
        emailLabel.textAlignment = .left
        self.pageScroll.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        emailTxt.setPlaceHolderText("Email")
        emailTxt.isUserInteractionEnabled = false
        emailTxt.textColor = kCustomTextColor
        self.pageScroll.addSubview(emailTxt)
        emailTxt.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let addressLabel = UILabel()
        addressLabel.text = "Address: "
        addressLabel.textColor = kDarkColor
        addressLabel.font = getCustomFont(size: 11, name: .light)
        addressLabel.textAlignment = .left
        self.pageScroll.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        addressTxt.setPlaceHolderText("Address")
        addressTxt.delegate = self
        addressTxt.rightAction = {
            self.righTextFieldButtonTapped(self.addressTxt)
        }
        addressTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        addressTxt.delegate = self
        self.pageScroll.addSubview(addressTxt)
        addressTxt.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let countryLabel = UILabel()
        countryLabel.text = "Country: "
        countryLabel.textColor = kDarkColor
        countryLabel.font = getCustomFont(size: 11, name: .light)
        countryLabel.textAlignment = .left
        self.pageScroll.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        countryTxt.setPlaceHolderText("Country")
        countryTxt.delegate = self
        countryTxt.rightAction = {
            self.righTextFieldButtonTapped(self.countryTxt)
        }
        countryTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        self.pageScroll.addSubview(countryTxt)
        countryTxt.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let regionLabel = UILabel()
        regionLabel.text = "Region: "
        regionLabel.textColor = kDarkColor
        regionLabel.font = getCustomFont(size: 11, name: .light)
        regionLabel.textAlignment = .left
        self.pageScroll.addSubview(regionLabel)
        regionLabel.snp.makeConstraints { make in
            make.top.equalTo(countryTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        regionTxt.setPlaceHolderText("Region")
        regionTxt.delegate = self
        regionTxt.rightAction = {
            self.righTextFieldButtonTapped(self.regionTxt)
        }
        regionTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        self.pageScroll.addSubview(regionTxt)
        regionTxt.snp.makeConstraints { make in
            make.top.equalTo(regionLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let provinceLabel = UILabel()
        provinceLabel.text = "Province: "
        provinceLabel.textColor = kDarkColor
        provinceLabel.font = getCustomFont(size: 11, name: .light)
        provinceLabel.textAlignment = .left
        self.pageScroll.addSubview(provinceLabel)
        provinceLabel.snp.makeConstraints { make in
            make.top.equalTo(regionTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        provinceTxt.setPlaceHolderText("Province")
        provinceTxt.delegate = self
        provinceTxt.rightAction = {
            self.righTextFieldButtonTapped(self.provinceTxt)
        }
        provinceTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        self.pageScroll.addSubview(provinceTxt)
        provinceTxt.snp.makeConstraints { make in
            make.top.equalTo(provinceLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let districtLabel = UILabel()
        districtLabel.text = "District: "
        districtLabel.textColor = kDarkColor
        districtLabel.font = getCustomFont(size: 11, name: .light)
        districtLabel.textAlignment = .left
        self.pageScroll.addSubview(districtLabel)
        districtLabel.snp.makeConstraints { make in
            make.top.equalTo(provinceTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        districtTxt.setPlaceHolderText("District")
        districtTxt.delegate = self
        districtTxt.rightAction = {
            self.righTextFieldButtonTapped(self.districtTxt)
        }
        districtTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        self.pageScroll.addSubview(districtTxt)
        districtTxt.snp.makeConstraints { make in
            make.top.equalTo(districtLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let wardLabel = UILabel()
        wardLabel.text = "Ward: "
        wardLabel.textColor = kDarkColor
        wardLabel.font = getCustomFont(size: 11, name: .light)
        wardLabel.textAlignment = .left
        self.pageScroll.addSubview(wardLabel)
        wardLabel.snp.makeConstraints { make in
            make.top.equalTo(districtTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        wardTxt.setPlaceHolderText("Ward")
        wardTxt.delegate = self
        wardTxt.rightAction = {
            self.righTextFieldButtonTapped(self.wardTxt)
        }
        wardTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        self.pageScroll.addSubview(wardTxt)
        wardTxt.snp.makeConstraints { make in
            make.top.equalTo(wardLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let postCodeLabel = UILabel()
        postCodeLabel.text = "Zipcode: "
        postCodeLabel.textColor = kDarkColor
        postCodeLabel.font = getCustomFont(size: 11, name: .light)
        postCodeLabel.textAlignment = .left
        self.pageScroll.addSubview(postCodeLabel)
        postCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(wardTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        postCodeTxt.setPlaceHolderText("Zipcode")
        postCodeTxt.delegate = self
        
        postCodeTxt.rightAction = {
            self.righTextFieldButtonTapped(self.postCodeTxt)
        }
        postCodeTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        self.pageScroll.addSubview(postCodeTxt)
        postCodeTxt.snp.makeConstraints { make in
            make.top.equalTo(postCodeLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }
        
        let professionLabel = UILabel()
        professionLabel.text = "Profession:"
        professionLabel.font = getCustomFont(size: 11, name: .light)
        professionLabel.textColor = kDarkColor
        professionLabel.textAlignment = .left
        self.pageScroll.addSubview(professionLabel)
        professionLabel.snp.makeConstraints { make in
            make.top.equalTo(postCodeTxt.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
        
        professionTxt.setPlaceHolderText("Profession")
        professionTxt.delegate = self
        professionTxt.rightAction = {
            self.righTextFieldButtonTapped(self.professionTxt)
        }
        professionTxt.setRightIcon(UIImage.init(named: "close_bar_icon"))
        self.pageScroll.addSubview(professionTxt)
        professionTxt.snp.makeConstraints { make in
            make.top.equalTo(professionLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        viewModel.getUserEHProfile()
    }
    
    // MARK: Binding Data
    override func bindingData() {
        _EHProfileServices.listProfiles
            .observe(on: MainScheduler.instance)
            .subscribe { listProfiles in
                if let mainProfile = listProfiles.element?.first {
//                    if let avatarImageURL = URL(string: mainProfile.avatar) {
//                        self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
//                    }
                    self.nameTxt.text = String(format: "%@ %@", mainProfile.firstName, mainProfile.lastName)
                    let dateDob = Date.init(timeIntervalSince1970: TimeInterval((mainProfile.dob ?? 0) / 1000))
                    self.dobTxt.text = String(format: "%@", dateDob.toString(dateFormat: "MMM dd, yyyy"))
                    self.genderTxt.text = String(format: "%@", (mainProfile.gender == .male) ? "Male" : "Female")
                    self.phoneNumberTxt.text = String(format: "%@", mainProfile.phone)
                    self.emailTxt.text = String(format: "%@", mainProfile.email)
                    
                    self.addressTxt.text = mainProfile.addressInfo?.address
                    self.countryTxt.text = mainProfile.addressInfo?.country
                    self.regionTxt.text = mainProfile.addressInfo?.region
                    self.provinceTxt.text = mainProfile.addressInfo?.province
                    self.districtTxt.text = mainProfile.addressInfo?.district
                    self.wardTxt.text = mainProfile.addressInfo?.ward
                    self.postCodeTxt.text = mainProfile.addressInfo?.postalCode
                    
                    self.professionTxt.text = mainProfile.profession
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Button
    @objc private func updateButtonTapped() {
        
        self.view.endEditing(true)
        
        guard let rootEHProfile = _EHProfileServices.listProfiles.value.first else {return}
        rootEHProfile.profession = self.professionTxt.text ?? ""
        var address = EHProfileAddress.init(JSONString: "{}")!
        address.address = self.addressTxt.text ?? ""
        address.country = self.countryTxt.text ?? ""
        address.region = self.regionTxt.text ?? ""
        address.province = self.provinceTxt.text ?? ""
        address.district = self.districtTxt.text ?? ""
        address.ward = self.wardTxt.text ?? ""
        address.postalCode = self.postCodeTxt.text ?? ""
        
        rootEHProfile.addressInfo = address
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let dobInt = rootEHProfile.dob {
            let date = Date.init(timeIntervalSince1970: TimeInterval(dobInt/1000))
            rootEHProfile.dobString = date.toISO8601String()
            rootEHProfile.dob = nil
        }
        
        self.viewModel.updateRootEHProfile(rootEHProfile)
    }
    
    private func righTextFieldButtonTapped(_ sender: BoundedIconTextField) {
        sender.text = ""
    }
}
