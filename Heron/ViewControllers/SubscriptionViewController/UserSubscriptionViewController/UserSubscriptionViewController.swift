//
//  UserSubscriptionViewController.swift
//  Heron
//
//  Created by Luu Luc on 28/08/2022.
//

import UIKit
import RxSwift
import RxCocoa

class UserSubscriptionViewController: BaseViewController {

    private let viewModel   = UserSubscriptionViewModel()
    
    let avatar              = UIImageView()
    let subsctionView       = UIView()
    let planButton          = UIButton() // tag = 0: Subscrible ; tag = 1: Switch plan
    let cancelPlanBtn       = UIButton()
    let tableView           = UITableView.init(frame: .zero, style: .plain)
    private var currentSub  : UserRegisteredSubscription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackBtn()
        self.title = "Subscriptions"
        
        self.viewModel.controller = self
        
        avatar.image = UIImage.init(named: "default-image")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.borderWidth = 1
        avatar.layer.cornerRadius = 8
        avatar.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        if let userData = _AppCoreData.userDataSource.value {
            if let avatarImageURL = URL(string: userData.userAvatarURL ) {
                self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
            }
        }
        
        subsctionView.backgroundColor = UIColor.init(hexString: "F0F0F0")
        self.view.addSubview(subsctionView)
        subsctionView.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(100)
        }
        
        planButton.tag = 0 // Subscription
        planButton.setTitle("Subscribe", for: .normal)
        planButton.setTitleColor(.white, for: .normal)
        planButton.backgroundColor = kPrimaryColor
        planButton.layer.cornerRadius = 8
        planButton.addTarget(self, action: #selector(subscriblePlanButtonTapped), for: .touchUpInside)
        self.view.addSubview(planButton)
        planButton.snp.makeConstraints { make in
            make.top.equalTo(subsctionView.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        
        cancelPlanBtn.setTitle("Cancel", for: .normal)
        cancelPlanBtn.setTitleColor(.white, for: .normal)
        cancelPlanBtn.backgroundColor = kRedHightLightColor
        cancelPlanBtn.layer.cornerRadius = 8
        cancelPlanBtn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.view.addSubview(cancelPlanBtn)
        cancelPlanBtn.snp.makeConstraints { make in
            make.top.equalTo(subsctionView.snp.bottom).offset(20)
            make.width.equalTo(planButton)
            make.left.equalTo(planButton.snp.right).offset(21)
            make.height.equalTo(50)
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(OrderedSubscriptionCell.self, forCellReuseIdentifier: "OrderedSubscriptionCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(planButton.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.getListUserSubscriptions()
    }
    
    private func reloadSubsciptionView(userSub: UserRegisteredSubscription) {
        for subView in self.subsctionView.subviews {
            subView.removeFromSuperview()
        }
        
        let statusLabel = UILabel()
        statusLabel.text = String(format: "Status: %@", userSub.getStatusText())
        statusLabel.textColor = kDefaultTextColor
        statusLabel.numberOfLines = 0
        statusLabel.textColor = UIColor.init(hexString: "444444")
        statusLabel.font = getFontSize(size: 14, weight: .regular)
        self.subsctionView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        let subscriptionNameLabel = UILabel()
        subscriptionNameLabel.text = String(format: "Type of Subs: %@", userSub.subsPlan?.subsItem?.name ?? "")
        subscriptionNameLabel.textColor = kDefaultTextColor
        subscriptionNameLabel.numberOfLines = 0
        subscriptionNameLabel.textColor = UIColor.init(hexString: "444444")
        subscriptionNameLabel.font = getFontSize(size: 14, weight: .regular)
        self.subsctionView.addSubview(subscriptionNameLabel)
        subscriptionNameLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        let startDateLabel = UILabel()
        let startDate = Date.init(timeIntervalSince1970: TimeInterval(userSub.enabledAt / 1000))
        startDateLabel.text = String(format: "From: %@", startDate.toString(dateFormat: "MMM dd, yyyy"))
        startDateLabel.textColor = kDefaultTextColor
        startDateLabel.numberOfLines = 0
        startDateLabel.textColor = UIColor.init(hexString: "444444")
        startDateLabel.font = getFontSize(size: 14, weight: .regular)
        self.subsctionView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(subscriptionNameLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        let endDateLabel = UILabel()
        let endDate = Date.init(timeIntervalSince1970: TimeInterval(userSub.disabledAt / 1000))
        endDateLabel.text = String(format: "Expiry at: %@", endDate.toString(dateFormat: "MMM dd, yyyy"))
        endDateLabel.textColor = kDefaultTextColor
        endDateLabel.numberOfLines = 0
        endDateLabel.textColor = UIColor.init(hexString: "444444")
        endDateLabel.font = getFontSize(size: 14, weight: .regular)
        self.subsctionView.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Data
    override func bindingData() {
        
        _AppCoreData.userDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { userDataSource in
                if let userData = userDataSource.element {
                    if let avatarImageURL = URL(string: userData?.userAvatarURL ?? "") {
                        self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        viewModel.listUserSunscriptions
            .observe(on: MainScheduler.instance)
            .subscribe { listUserSubscriptions in
                
                guard let listUserSubs = listUserSubscriptions.element else {return}
                
                for subView in self.subsctionView.subviews {
                    subView.removeFromSuperview()
                }
                
                if let currentlyNS = listUserSubs.first(where: { userRegisteredSubscription in
                    return userRegisteredSubscription.customStatus == .CURRENTLY_NS
                }) {
                    
                    self.currentSub = currentlyNS
                    
                    self.view.addSubview(self.planButton)
                    self.planButton.snp.remakeConstraints { make in
                        make.top.equalTo(self.subsctionView.snp.bottom).offset(20)
                        make.left.equalToSuperview().offset(20)
                        make.height.equalTo(50)
                        make.width.equalToSuperview().multipliedBy(0.5).offset(-30)
                    }
                    
                    self.reloadSubsciptionView(userSub: currentlyNS)
                    self.planButton.tag = 1
                    self.planButton.setTitle("Switch plan", for: .normal)
                    
                    self.cancelPlanBtn.setTitle("Cancel", for: .normal)
                    return
                }
                
                if let currentlyST = listUserSubs.first(where: { userRegisteredSubscription in
                    return userRegisteredSubscription.customStatus == .CURRENTLY_ST
                }) {
                    
                    self.currentSub = currentlyST
                    
                    self.view.addSubview(self.planButton)
                    self.planButton.snp.remakeConstraints { make in
                        make.top.equalTo(self.subsctionView.snp.bottom).offset(20)
                        make.left.equalToSuperview().offset(20)
                        make.height.equalTo(50)
                        make.width.equalToSuperview().multipliedBy(0.5).offset(-30)
                    }
                    
                    self.reloadSubsciptionView(userSub: currentlyST)
                    self.planButton.tag = 2
                    self.planButton.setTitle("Switch plan", for: .normal)
                    return
                }

                // User do not have any sub
                let statusLabel = UILabel()
                statusLabel.text = String(format: "Status: Don't have any active subscriptions")
                statusLabel.textColor = kDefaultTextColor
                statusLabel.numberOfLines = 0
                statusLabel.textColor = UIColor.init(hexString: "444444")
                statusLabel.font = getFontSize(size: 14, weight: .regular)
                self.subsctionView.addSubview(statusLabel)
                statusLabel.snp.makeConstraints { make in
                    make.top.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                    make.bottom.lessThanOrEqualToSuperview().offset(-10)
                }
                
                self.view.addSubview(self.planButton)
                self.planButton.snp.remakeConstraints { make in
                    make.top.equalTo(self.subsctionView.snp.bottom).offset(20)
                    make.width.equalToSuperview().offset(-40)
                    make.left.equalToSuperview().offset(20)
                    make.height.equalTo(50)
                }
                
                self.view.layoutIfNeeded()
                self.planButton.tag = 0
                self.planButton.setTitle("Subscribe", for: .normal)
            }
            .disposed(by: self.disposeBag)
        
        viewModel.listUserSunscriptions
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { (_: UITableView, _: Int, element: UserRegisteredSubscription) in
                let cell = OrderedSubscriptionCell(style: .default, reuseIdentifier:"OrderedSubscriptionCell")
                cell.setDataSource(element)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    @objc private func subscriblePlanButtonTapped() {
        if self.planButton.tag == 0 {
            // Subscription
            let mainSubscriptionVC = MainSubscriptionViewController()
            _NavController.pushViewController(mainSubscriptionVC, animated: true)
        } else if self.planButton.tag == 1 {
            // Switch plan immediately
            let alertVC = UIAlertController.init(title: NSLocalizedString("Switch plan?", comment: ""),
                                                 message: "If you swicth plan, you will loss current plan time lefr",
                                                 preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Switch Immediately", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
                let mainSubscriptionVC = MainSubscriptionViewController()
                mainSubscriptionVC.currentlySub = self.currentSub
                _NavController.pushViewController(mainSubscriptionVC, animated: true)
            }))
//            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Switch when current plan exprired", comment: ""), style: .default, handler: { _ in
//                alertVC.dismiss()
//                // cancel auto subscription and sub to new one
//                self.viewModel.cancelCurrentlySubscription(false)
//                let mainSubscriptionVC = MainSubscriptionViewController()
//                _NavController.pushViewController(mainSubscriptionVC, animated: true)
//            }))
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
        } else if self.planButton.tag == 2 {
            // Switch plan immediately
            let alertVC = UIAlertController.init(title: NSLocalizedString("Switch plan?", comment: ""),
                                                 message: "If you swicth plan, you will automatic switch to new plan when current plan exprired",
                                                 preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Switch", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
                let mainSubscriptionVC = MainSubscriptionViewController()
                mainSubscriptionVC.currentlySub = self.currentSub
                _NavController.pushViewController(mainSubscriptionVC, animated: true)
            }))
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
        }
    }
    
    @objc private func cancelButtonTapped() {
        // Cancel auto renew subscription
        let alertVC = UIAlertController.init(title: NSLocalizedString("Cancel subscription?", comment: ""),
                                             message: "Are you sure to cancel current subscription?",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Stop now", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
            self.viewModel.cancelCurrentlySubscription(true)
        }))
//        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel auto-renew", comment: ""), style: .default, handler: { _ in
//            alertVC.dismiss()
//            self.viewModel.cancelCurrentlySubscription(false)
//        }))
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Nope", comment: ""), style: .cancel, handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
}
