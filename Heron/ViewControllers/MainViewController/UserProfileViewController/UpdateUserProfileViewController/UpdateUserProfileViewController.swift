//
//  UpdateEHealthProfileViewController.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit
import RxSwift
import Material

class UpdateUserProfileViewController: BaseViewController {

    private let viewModel   = UpdateUserProfileViewModel()
    let avatar              = UIImageView()
    let nameLabel           = UILabel()
    let dobLabel            = UILabel()
    let genderLabel         = UILabel()
    let phoneLabel          = UILabel()
    let emailLabel          = UILabel()
    
    private let addressTxt      = ErrorTextField()
    private let countryTxt      = ErrorTextField()
    private let cityTxt         = ErrorTextField()
    private let postCodeTxt     = ErrorTextField()
    private let professionTxt   = ErrorTextField()
    
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
        
        cityTxt.placeholder = "City"
        cityTxt.dividerNormalHeight = 0.5
        cityTxt.dividerNormalColor = kPrimaryColor
        cityTxt.errorColor = .red
        cityTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(cityTxt)
        cityTxt.snp.makeConstraints { make in
            make.top.equalTo(countryTxt.snp.bottom).offset(40)
            make.left.equalTo(contentView)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        postCodeTxt.placeholder = "Post Code"
        postCodeTxt.dividerNormalHeight = 0.5
        postCodeTxt.dividerNormalColor = kPrimaryColor
        postCodeTxt.errorColor = .red
        postCodeTxt.textColor = kDefaultTextColor
        self.pageScroll.addSubview(postCodeTxt)
        postCodeTxt.snp.makeConstraints { make in
            make.top.equalTo(cityTxt.snp.bottom).offset(40)
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
        
        let completeBtn = UIButton()
        completeBtn.backgroundColor = kPrimaryColor
        completeBtn.layer.cornerRadius = 8
        completeBtn.setTitle("Complete", for: .normal)
        completeBtn.setTitleColor(.white, for: .normal)
        completeBtn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        self.pageScroll.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { make in
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
        viewModel.getUserProfile()
    }
    
    // MARK: Binding Data
    override func bindingData() {
        _AppCoreData.userDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { userDataSource in
                if let userData = userDataSource.element {
                    if let avatarImageURL = URL(string: userData?.userAvatarURL ?? "") {
                        self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
                    }
                    self.nameLabel.text = String(format: "Name: %@ %@", userData?.userFirstName ?? "",userData?.userLastName ?? "")
                    let dateDob = Date.init(timeIntervalSince1970: TimeInterval((userData?.userDOB ?? 0) / 1000))
                    self.dobLabel.text = String(format: "DOB: %@", dateDob.toString(dateFormat: "dd/MM/yyyy"))
                    self.genderLabel.text = String(format: "Gender: %@", (userData?.userGender == .male) ? "Male" : "Female")
                    self.phoneLabel.text = String(format: "Phone number: %@%@", userData?.userPhoneCode ?? "", userData?.userPhoneNum ?? "")
                    self.emailLabel.text = String(format: "Email : %@", userData?.userEmail ?? "")
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func completeButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature do not available right now.\nPlease try again in next build", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Gotcha", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
}
