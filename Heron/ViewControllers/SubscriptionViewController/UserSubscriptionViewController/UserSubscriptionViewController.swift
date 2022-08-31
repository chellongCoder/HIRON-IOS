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
    let actionButton        = UIButton() // tag = 0: Cancel; tag = 1: Subscription
    let tableView           = UITableView.init(frame: .zero, style: .plain)
    
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
        
        actionButton.tag = 1 // Subscription
        actionButton.setTitle("Subscribe", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = kPrimaryColor
        actionButton.layer.cornerRadius = 8
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        self.view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(subsctionView.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(OrderedSubscriptionCell.self, forCellReuseIdentifier: "OrderedSubscriptionCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(actionButton.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getListUserSubscriptions()
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
                
                if let currentSubs = self.viewModel.getCurrentSubscription(listUserSubs) {
                    let statusLabel = UILabel()
                    statusLabel.text = String(format: "Status: %@", currentSubs.getStatusText())
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
                    subscriptionNameLabel.text = String(format: "Type of Subs: %@", currentSubs.subsPlan?.subsItem?.name ?? "")
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
                    let startDate = Date.init(timeIntervalSince1970: TimeInterval(currentSubs.enabledAt / 1000))
                    startDateLabel.text = String(format: "From: %@", startDate.toString(dateFormat: "dd, MMM yyyy"))
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
                    let endDate = Date.init(timeIntervalSince1970: TimeInterval(currentSubs.disabledAt / 1000))
                    endDateLabel.text = String(format: "Expiry at: %@", endDate.toString(dateFormat: "dd, MMM yyyy"))
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
                    self.actionButton.tag = 0
                    self.actionButton.setTitle("Cancel", for: .normal)
                    return
                } else {
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
                    
                    self.view.layoutIfNeeded()
                    self.actionButton.tag = 1
                    self.actionButton.setTitle("Subscribe", for: .normal)
                }
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
    @objc private func actionButtonTapped() {
        if self.actionButton.tag == 1 {
            // Subscription
            let mainSubscriptionVC = MainSubscriptionViewController()
            _NavController.pushViewController(mainSubscriptionVC, animated: true)
        } else if self.actionButton.tag == 0 {
            // Cancel
            let alertVC = UIAlertController.init(title: NSLocalizedString("Confirm", comment: ""),
                                                 message: "Are you sure to cancel currently subscription?",
                                                 preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel immediately", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
                self.viewModel.cancelCurrentlySubscription(true)
            }))
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel auto renewable", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
                self.viewModel.cancelCurrentlySubscription(false)
            }))
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Keep using", comment: ""), style: .cancel, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
        }
    }
}
