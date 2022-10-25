//
//  UpdateEHProfileViewController.swift
//  Heron
//
//  Created by Luu Luc on 05/09/2022.
//

import UIKit
import RxSwift
import Material

class UpdateEHProfileViewController: PageScrollViewController {
    private let viewModel   = UpdateEHProfileViewModel()
    
    let avatar              = UIImageView()
    let nameLabel           = UILabel()
    let dobLabel            = UILabel()
    let genderLabel         = UILabel()
    let phoneLabel          = UILabel()
    let emailLabel          = UILabel()
    
    private let addressTxt      = ErrorTextField()
    private let countryTxt      = ErrorTextField()
    private let regionTxt       = ErrorTextField()
    private let provinceTxt     = ErrorTextField()
    private let districtTxt     = ErrorTextField()
    private let wardTxt         = ErrorTextField()
    private let postCodeTxt     = ErrorTextField()
    private let professionTxt   = ErrorTextField()

    let updateBtn           = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update E-Health Profile"
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
            make.width.equalToSuperview().offset(-40)
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
        
        addressTxt.placeholder = "Address"
        addressTxt.dividerNormalHeight = 0.5
        addressTxt.dividerNormalColor = kPrimaryColor
        addressTxt.errorColor = .red
        addressTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(addressTxt)
        addressTxt.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        countryTxt.placeholder = "Country"
        countryTxt.dividerNormalHeight = 0.5
        countryTxt.dividerNormalColor = kPrimaryColor
        countryTxt.errorColor = .red
        countryTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(countryTxt)
        countryTxt.snp.makeConstraints { make in
            make.top.equalTo(addressTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        regionTxt.placeholder = "Region"
        regionTxt.dividerNormalHeight = 0.5
        regionTxt.dividerNormalColor = kPrimaryColor
        regionTxt.errorColor = .red
        regionTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(regionTxt)
        regionTxt.snp.makeConstraints { make in
            make.top.equalTo(countryTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        provinceTxt.placeholder = "Province"
        provinceTxt.dividerNormalHeight = 0.5
        provinceTxt.dividerNormalColor = kPrimaryColor
        provinceTxt.errorColor = .red
        provinceTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(provinceTxt)
        provinceTxt.snp.makeConstraints { make in
            make.top.equalTo(regionTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        districtTxt.placeholder = "District"
        districtTxt.dividerNormalHeight = 0.5
        districtTxt.dividerNormalColor = kPrimaryColor
        districtTxt.errorColor = .red
        districtTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(districtTxt)
        districtTxt.snp.makeConstraints { make in
            make.top.equalTo(provinceTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        wardTxt.placeholder = "Ward"
        wardTxt.dividerNormalHeight = 0.5
        wardTxt.dividerNormalColor = kPrimaryColor
        wardTxt.errorColor = .red
        wardTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(wardTxt)
        wardTxt.snp.makeConstraints { make in
            make.top.equalTo(districtTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        postCodeTxt.placeholder = "Zip Code"
        postCodeTxt.dividerNormalHeight = 0.5
        postCodeTxt.dividerNormalColor = kPrimaryColor
        postCodeTxt.errorColor = .red
        postCodeTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(postCodeTxt)
        postCodeTxt.snp.makeConstraints { make in
            make.top.equalTo(wardTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        professionTxt.placeholder = "Profession"
        professionTxt.dividerNormalHeight = 0.5
        professionTxt.dividerNormalColor = kPrimaryColor
        professionTxt.errorColor = .red
        professionTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(professionTxt)
        professionTxt.snp.makeConstraints { make in
            make.top.equalTo(postCodeTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        updateBtn.backgroundColor = kPrimaryColor
        updateBtn.layer.cornerRadius = 8
        updateBtn.setTitle("Complete", for: .normal)
        updateBtn.setTitleColor(.white, for: .normal)
        updateBtn.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        self.pageScroll.addSubview(updateBtn)
        updateBtn.snp.makeConstraints { make in
            make.top.equalTo(professionTxt.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
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
                    if let avatarImageURL = URL(string: mainProfile.avatar) {
                        self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
                    }
                    self.nameLabel.text = String(format: "Name: %@ %@", mainProfile.firstName, mainProfile.lastName)
                    let dateDob = Date.init(timeIntervalSince1970: TimeInterval((mainProfile.dob ?? 0) / 1000))
                    self.dobLabel.text = String(format: "DOB: %@", dateDob.toString(dateFormat: "MMM dd, yyyy"))
                    self.genderLabel.text = String(format: "Gender: %@", (mainProfile.gender == .male) ? "Male" : "Female")
                    self.phoneLabel.text = String(format: "Phone number: %@", mainProfile.phone)
                    self.emailLabel.text = String(format: "Email : %@", mainProfile.email)
                    
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
}
