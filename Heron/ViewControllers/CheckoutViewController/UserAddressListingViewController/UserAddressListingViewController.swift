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
                                        UserAddressCellDelegate {
    
    private let tableView           = UITableView()
    private let addNewAddressBtn    = UIButton()
    var acceptance                  : BehaviorRelay<ContactDataSource?>?
    
    private let viewModel           = UserAddressListingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "User's Address"
        
        self.showBackBtn()
        
        addNewAddressBtn.backgroundColor = kPrimaryColor
        addNewAddressBtn.setTitle("ADD NEW ADDRESS", for: .normal)
        addNewAddressBtn.setTitleColor(.white, for: .normal)
        addNewAddressBtn.layer.cornerRadius = 8
        addNewAddressBtn.addTarget(self, action: #selector(addNewAddressButtonTapped), for: .touchUpInside)
        self.view.addSubview(addNewAddressBtn)
        addNewAddressBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(UserAddressCell.self, forCellReuseIdentifier: "UserAddressCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalTo(addNewAddressBtn.snp.top).offset(-10)
        }
        
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getListUserAddress()
    }
    
    // MARK: - Buttons
    
    @objc private func addNewAddressButtonTapped() {
        let newAddressVC = AddUserAddressViewController()
        self.navigationController?.pushViewController(newAddressVC, animated: true)
    }
    
    // MARK: - Datas
    override func bindingData() {
        _DeliveryServices.listUserAddress
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: ContactDataSource) in
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
}
