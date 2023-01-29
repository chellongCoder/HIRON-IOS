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
    let planView            = PlanView()
    let voucherInfo         = UserDashboardItem()
    let pointInfo           = UserDashboardItem()
    let giftCardInfo        = UserDashboardItem()
    
    private let updateProfileBtn    = UserProfileActionBtn()
    private let updateEHProfileBtn  = UserProfileActionBtn()
    private let userSubscriptions   = UserProfileActionBtn()
    private let userWishlistBtn   = UserProfileActionBtn()

    private let signOutBtn          = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        self.title = "Profile"
        self.view.backgroundColor = kPrimaryColor
        
        let cricle1 = UIView()
        cricle1.backgroundColor = kCircleBackgroundColor
        cricle1.layer.cornerRadius = 90
        self.view.addSubview(cricle1)
        cricle1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(20)
            make.height.width.equalTo(180)
        }
        
        let cricle2 = UIView()
        cricle2.backgroundColor = kCircleBackgroundColor
        cricle2.layer.cornerRadius = 56
        self.view.addSubview(cricle2)
        cricle2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(165)
            make.left.equalToSuperview().offset(-15)
            make.height.width.equalTo(112)
        }
        
        avatar.image = UIImage.init(named: "avatar_default")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.borderWidth = 12
        avatar.layer.cornerRadius = 60
        self.view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        nameLabel.text = ""
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = getCustomFont(size: 16, name: .bold)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        planView.layer.cornerRadius = 15
        self.view.addSubview(planView)
        planView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    
        pointInfo.layer.cornerRadius = 10
        pointInfo.layer.masksToBounds = true
        self.view.addSubview(pointInfo)
        pointInfo.snp.makeConstraints { make in
            make.top.equalTo(planView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(68)
        }
        
        voucherInfo.layer.cornerRadius = 10
        voucherInfo.layer.masksToBounds = true
        self.view.addSubview(voucherInfo)
        voucherInfo.snp.makeConstraints { make in
            make.top.equalTo(pointInfo.snp.top)
            make.right.equalTo(pointInfo.snp.left).offset(-30)
            make.height.width.equalTo(pointInfo)
        }
        
        giftCardInfo.layer.cornerRadius = 10
        giftCardInfo.layer.masksToBounds = true
        self.view.addSubview(giftCardInfo)
        giftCardInfo.snp.makeConstraints { make in
            make.top.equalTo(pointInfo)
            make.height.width.equalTo(pointInfo)
            make.left.equalTo(pointInfo.snp.right).offset(30)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 40
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(pointInfo.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        updateProfileBtn.actionName.text = "Update User Profile"
        updateProfileBtn.actionIcon.image = UIImage.init(named: "user_profile_icon")
        updateProfileBtn.addTarget(self, action: #selector(updateUserProfileButtonTapped), for: .touchUpInside)
        contentView.addSubview(updateProfileBtn)
        updateProfileBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        updateEHProfileBtn.actionName.text = "Update E-Health Profile"
        updateEHProfileBtn.actionIcon.image = UIImage.init(named: "user_ehp_profile_icon")
        updateEHProfileBtn.addTarget(self, action: #selector(updateEHProfileButtonTapped), for: .touchUpInside)
        contentView.addSubview(updateEHProfileBtn)
        updateEHProfileBtn.snp.makeConstraints { make in
            make.top.equalTo(updateProfileBtn.snp.bottom).offset(5)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        userSubscriptions.actionName.text = "Subscription Management"
        userSubscriptions.actionIcon.image = UIImage.init(named: "user_supscription_icon")
        userSubscriptions.addTarget(self, action: #selector(userSubscriptionButtonTapped), for: .touchUpInside)
        contentView.addSubview(userSubscriptions)
        userSubscriptions.snp.makeConstraints { make in
            make.top.equalTo(updateEHProfileBtn.snp.bottom).offset(5)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        userWishlistBtn.actionName.text = "Wishlists"
        userWishlistBtn.actionIcon.image = UIImage.init(named: "user_supscription_icon")
        userWishlistBtn.addTarget(self, action: #selector(userWishlistButtonTapped), for: .touchUpInside)
        contentView.addSubview(userWishlistBtn)
        userWishlistBtn.snp.makeConstraints { make in
            make.top.equalTo(userSubscriptions.snp.bottom).offset(5)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        signOutBtn.setTitle("Sign out", for: .normal)
        signOutBtn.setTitleColor(kPrimaryColor, for: .normal)
        signOutBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        signOutBtn.backgroundColor = .white
        signOutBtn.layer.cornerRadius = 20
        signOutBtn.layer.borderColor = kPrimaryColor.cgColor
        signOutBtn.layer.borderWidth = 1.5
        signOutBtn.addTarget(self, action: #selector(signoutButtonTapped), for: .touchUpInside)
        contentView.addSubview(signOutBtn)
        signOutBtn.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-56)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-31)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.getUserProfile()
        viewModel.getUserSubscription()
    }
    
    // MARK: Binding Data
    override func bindingData() {
        _AppCoreData.userDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { userDataSource in
                if let userData = userDataSource.element {
                    if let avatarImageURL = URL(string: userData?.userAvatarURL ?? "") {
                        self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "avatar_default")!)
                    }
                    self.nameLabel.text = String(format: "%@ %@", userData?.userFirstName ?? "", userData?.userLastName ?? "")
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
        _NavController.pushViewController(updateEHProfileVC, animated: true)
    }
    
    @objc private func updateEHProfileButtonTapped() {
        let updateEHProfileVC = UpdateEHProfileViewController()
        _NavController.pushViewController(updateEHProfileVC, animated: true)
    }
    
    @objc private func userSubscriptionButtonTapped() {
        let listUserSubscriptionVC = UserSubscriptionViewController()
        _NavController.pushViewController(listUserSubscriptionVC, animated: true)
    }
    
    @objc private func userWishlistButtonTapped() {
        let wishlistProductVC = WishListProductController()
        _NavController.pushViewController(wishlistProductVC, animated: true)
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
