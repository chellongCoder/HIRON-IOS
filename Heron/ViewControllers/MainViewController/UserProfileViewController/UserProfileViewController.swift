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
    
    private let myOrderBtn          = UIButton()
    private let myAppointmentBtn    = UIButton()
    private let updateEHPBtn        = UIButton()
    private let userSubscriptions   = UIButton()
    private let signOutBtn          = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        viewModel.controller = self
        
        avatar.image = UIImage.init(named: "default-image")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.borderWidth = 1
        avatar.layer.cornerRadius = 8
        avatar.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
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
        
        myOrderBtn.setTitle("My Order", for: .normal)
        myOrderBtn.setTitleColor(kPrimaryColor, for: .normal)
        myOrderBtn.layer.borderColor = kPrimaryColor.cgColor
        myOrderBtn.layer.cornerRadius = 8
        myOrderBtn.layer.borderWidth = 1
        myOrderBtn.addTarget(self, action: #selector(myOrderButtonTapped), for: .touchUpInside)
        self.view.addSubview(myOrderBtn)
        myOrderBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
            make.right.equalTo(self.view.snp.centerX).offset(-10)
        }
        
        myAppointmentBtn.setTitle("My Appointment", for: .normal)
        myAppointmentBtn.setTitleColor(kPrimaryColor, for: .normal)
        myAppointmentBtn.layer.borderColor = kPrimaryColor.cgColor
        myAppointmentBtn.layer.cornerRadius = 8
        myAppointmentBtn.layer.borderWidth = 1
        myAppointmentBtn.addTarget(self, action: #selector(myAppointmentButtonTapped), for: .touchUpInside)
        self.view.addSubview(myAppointmentBtn)
        myAppointmentBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.left.equalTo(self.view.snp.centerX).offset(10)
        }
        
        updateEHPBtn.setTitle("Update Profile", for: .normal)
        updateEHPBtn.setTitleColor(.white, for: .normal)
        updateEHPBtn.backgroundColor = kPrimaryColor
        updateEHPBtn.layer.cornerRadius = 8
        updateEHPBtn.addTarget(self, action: #selector(updateUserProfileButtonTapped), for: .touchUpInside)
        self.view.addSubview(updateEHPBtn)
        updateEHPBtn.snp.makeConstraints { make in
            make.top.equalTo(myOrderBtn.snp.bottom).offset(20)
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
            make.top.equalTo(updateEHPBtn.snp.bottom).offset(5)
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
                    self.nameLabel.text = String(format: "Name: %@ %@", userData?.userFirstName ?? "", userData?.userLastName ?? "")
                    let dateDob = Date.init(timeIntervalSince1970: TimeInterval((userData?.userDOB ?? 0) / 1000))
                    self.dobLabel.text = String(format: "DOB: %@", dateDob.toString(dateFormat: "dd/MM/yyyy"))
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
        let myAppointmentVC = MyAppointmentViewController()
        self.navigationController?.pushViewController(myAppointmentVC, animated: true)
    }
    
    @objc private func updateUserProfileButtonTapped() {
        let updateEHProfileVC = UpdateUserProfileViewController()
        self.navigationController?.pushViewController(updateEHProfileVC, animated: true)
    }
    
    @objc private func userSubscriptionButtonTapped() {
        let listUserSubscriptionVC = UserSubscriptionViewController()
        self.navigationController?.pushViewController(listUserSubscriptionVC, animated: true)
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
