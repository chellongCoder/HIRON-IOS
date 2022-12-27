//
//  UserAddressListingViewController.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

class UserAddressListingViewController: BaseViewController,
                                        UITableViewDelegate,
                                        UserAddressCellDelegate,
                                        EmptyViewDelegate {
    
    private let tableView           = UITableView()
    private let emptyView           = EmptyView()
    private let addNewAddressBtn    = UIButton()
    private let addedView           = UIView()
    var acceptance                  : BehaviorRelay<ContactDataSource?>?
    
    private let viewModel           = UserAddressListingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "My Address"
        
        self.showBackBtn()
        
        addNewAddressBtn.backgroundColor = kPrimaryColor
        addNewAddressBtn.layer.cornerRadius = 20
        addNewAddressBtn.addTarget(self, action: #selector(addNewAddressButtonTapped), for: .touchUpInside)
        self.view.addSubview(addNewAddressBtn)
        addNewAddressBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        
        let buttonTitle = UILabel()
        buttonTitle.text = "Add new address"
        buttonTitle.textColor = .white
        buttonTitle.font = getCustomFont(size: 14, name: .bold)
        addNewAddressBtn.addSubview(buttonTitle)
        buttonTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(20)
        }
        
        let buttonIcon = UIImageView()
        buttonIcon.image = UIImage.init(named: "plus_icon")
        addNewAddressBtn.addSubview(buttonIcon)
        buttonIcon.snp.makeConstraints { make in
            make.right.equalTo(buttonTitle.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(14)
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(UserAddressCell.self, forCellReuseIdentifier: "UserAddressCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalTo(addNewAddressBtn.snp.top).offset(-10)
        }
        
        emptyView.imageView.image = UIImage.init(named: "noSearchResult")
        emptyView.titleLabel.text = "You current don't have any Delivery Address for us to ship"
        emptyView.messageLabel.text = "Please add your delivery address"
        emptyView.delegate = self
        emptyView.actionButon.isHidden = true
        emptyView.isHidden = true
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.size.equalTo(tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getListUserAddress()
    }
    
    // MARK: - Buttons
    
    @objc private func addNewAddressButtonTapped() {
        
        let newAddressVC = AddUserAddressViewController()
        if _DeliveryServices.listUserAddress.value.isEmpty {
            // First address
            let userProfile = _AppCoreData.userDataSource.value
            var newContact = ContactDataSource.init(JSONString: "{}", context: nil)!
            newContact.firstName = userProfile?.userFirstName ?? ""
            newContact.lastName = userProfile?.userLastName ?? ""
            newContact.phone = String(format: "%@%@", userProfile?.userPhoneCode ?? "", userProfile?.userPhoneNum ?? "")
            newContact.email = userProfile?.userEmail ?? ""
            
            newContact.isDefault = true
            
            newAddressVC.viewModel.contact.accept(newContact)
        }
        
        self.navigationController?.pushViewController(newAddressVC, animated: true)
    }
    
    // MARK: - Datas
    override func bindingData() {
        _DeliveryServices.listUserAddress
            .observe(on: MainScheduler.instance)
            .subscribe { listAddress in
                if (listAddress.element ?? []).isEmpty {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        _DeliveryServices.listUserAddress
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { (_: UITableView, _: Int, element: ContactDataSource) in
                let cell = UserAddressCell(style: .default, reuseIdentifier:"UserAddressCell")
                cell.setDataSource(element)
                cell.delegate = self
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(ContactDataSource.self)
            .subscribe { model in
                guard let contactData = model.element else {return}
                self.acceptance?.accept(contactData)
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.animation
            .observe(on: MainScheduler.instance)
            .subscribe { animation in
                if (animation.element ?? false) {
                    self.startLoadingAnimation()
                } else {
                    self.endLoadingAnimation()
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UserAddressCellDelegate
    func didEditAddress(_ address: ContactDataSource) {
        let newAddressVC = AddUserAddressViewController()
        newAddressVC.viewModel.contact.accept(address)
        newAddressVC.viewModel.isUpdated = true
        self.navigationController?.pushViewController(newAddressVC, animated: true)
    }
    
    // MARK: - EmptyViewDelegate
    func didSelectEmptyButton() {
        self.addNewAddressButtonTapped()
    }
}
