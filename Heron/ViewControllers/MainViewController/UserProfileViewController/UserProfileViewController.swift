//
//  UserProfileViewController.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit
import RxSwift

class UserProfileViewController: BaseViewController {
    
    private let viewModel   = UserProfileViewModel()
    
    let avatar              = UIImageView()
    let nameLabel           = UILabel()
    let dobLabel            = UILabel()
    let genderLabel         = UILabel()
    let phoneLabel          = UILabel()
    let emailLabel          = UILabel()
    
    private let updateProfileBtn    = UIButton()
    private let updateEHProfileBtn  = UIButton()
    private let userSubscriptions   = UIButton()
    private let signOutBtn          = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        
        avatar.image = UIImage.init(named: "default-image")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.borderWidth = 1
        avatar.layer.cornerRadius = 8
        avatar.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.init(hexString: "F0F0F0")
        self.view.addSubview(contentView)
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
                
        updateProfileBtn.setTitle("Update User Profile", for: .normal)
        updateProfileBtn.setTitleColor(.white, for: .normal)
        updateProfileBtn.backgroundColor = kPrimaryColor
        updateProfileBtn.layer.cornerRadius = 8
        updateProfileBtn.addTarget(self, action: #selector(updateUserProfileButtonTapped), for: .touchUpInside)
        self.view.addSubview(updateProfileBtn)
        updateProfileBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        updateEHProfileBtn.setTitle("Update E-Health Profile", for: .normal)
        updateEHProfileBtn.setTitleColor(.white, for: .normal)
        updateEHProfileBtn.backgroundColor = kPrimaryColor
        updateEHProfileBtn.layer.cornerRadius = 8
        updateEHProfileBtn.addTarget(self, action: #selector(updateEHProfileButtonTapped), for: .touchUpInside)
        self.view.addSubview(updateEHProfileBtn)
        updateEHProfileBtn.snp.makeConstraints { make in
            make.top.equalTo(updateProfileBtn.snp.bottom).offset(5)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        userSubscriptions.setTitle("User Subscriptions", for: .normal)
        userSubscriptions.setTitleColor(.white, for: .normal)
        userSubscriptions.backgroundColor = kPrimaryColor
        userSubscriptions.layer.cornerRadius = 8
        userSubscriptions.addTarget(self, action: #selector(userSubscriptionButtonTapped), for: .touchUpInside)
        self.view.addSubview(userSubscriptions)
        userSubscriptions.snp.makeConstraints { make in
            make.top.equalTo(updateEHProfileBtn.snp.bottom).offset(5)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        signOutBtn.setTitle("Sign Out", for: .normal)
        signOutBtn.setTitleColor(.white, for: .normal)
        signOutBtn.backgroundColor = kRedHightLightColor
        signOutBtn.layer.cornerRadius = 8
        signOutBtn.addTarget(self, action: #selector(signoutButtonTapped), for: .touchUpInside)
        self.view.addSubview(signOutBtn)
        signOutBtn.snp.makeConstraints { make in
            make.top.equalTo(userSubscriptions.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                    self.nameLabel.text = String(format: "Name: %@ %@", userData?.userFirstName ?? "", userData?.userLastName ?? "")
                    let dateDob = Date.init(timeIntervalSince1970: TimeInterval((userData?.userDOB ?? 0) / 1000))
                    self.dobLabel.text = String(format: "DOB: %@", dateDob.toString(dateFormat: "MMM dd, yyyy"))
                    self.genderLabel.text = String(format: "Gender: %@", (userData?.userGender == .male) ? "Male" : "Female")
                    self.phoneLabel.text = String(format: "Phone number: %@%@", userData?.userPhoneCode ?? "", userData?.userPhoneNum ?? "")
                    self.emailLabel.text = String(format: "Email : %@", userData?.userEmail ?? "")
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Buttons
    @objc private func myOrderButtonTapped() {
        let myOrderVC = MyOrderViewController()
        self.navigationController?.pushViewController(myOrderVC, animated: true)
    }
    
    @objc private func myAppointmentButtonTapped() {
        let myAppointmentVC = MyBookingsViewController()
        _NavController.pushViewController(myAppointmentVC, animated: true)
    }
    
    @objc private func updateUserProfileButtonTapped() {
        let updateEHProfileVC = UpdateUserProfileViewController()
        self.navigationController?.pushViewController(updateEHProfileVC, animated: true)
    }
    
    @objc private func updateEHProfileButtonTapped() {
        let updateEHProfileVC = UpdateEHProfileViewController()
        self.navigationController?.pushViewController(updateEHProfileVC, animated: true)
    }
    
    @objc private func userSubscriptionButtonTapped() {
        let listUserSubscriptionVC = UserSubscriptionViewController()
        _NavController.pushViewController(listUserSubscriptionVC, animated: true)
    }
    
    @objc private func signoutButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Sign out", comment: ""),
                                             message: "Are you sure to sign out?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
            _AppCoreData.signOut()
            _NavController.gotoLoginPage()
        }))
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
}
