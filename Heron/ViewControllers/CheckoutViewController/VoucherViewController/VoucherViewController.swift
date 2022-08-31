//
//  VoucherViewController.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Material

class VoucherViewController: BaseViewController, VoucherTableViewCellDelegate,
                             UITableViewDataSource {
    
    let codeTxt         = ErrorTextField()
    let applyBtn        = UIButton()
    
    let tableView       = UITableView()
    
    private let viewModel   = VoucherViewModel()
    var acceptance          : BehaviorRelay<VoucherDataSource?>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "Vouchers"
        
        self.showBackBtn()
        
        applyBtn.backgroundColor = kPrimaryColor
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.setTitle("Apply", for: .normal)
        self.view.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        
        codeTxt.placeholder = "Voucher Code"
        codeTxt.dividerNormalHeight = 0.5
        codeTxt.dividerNormalColor = kPrimaryColor
        codeTxt.errorColor = .red
        codeTxt.textColor = kDefaultTextColor
        self.view.addSubview(codeTxt)
        codeTxt.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(10)
            make.right.equalTo(applyBtn.snp.left).offset(-10)
            make.height.equalTo(50)
        }
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(VoucherTableViewCell.self, forCellReuseIdentifier: "VoucherTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(codeTxt.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getListVoucher()
    }
    
    // MARK: - Data
    override func bindingData() {
        viewModel.listUserVouchers
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.animation
            .observe(on: MainScheduler.instance)
            .subscribe { isLoading in
                if (isLoading.element ?? false) {
                    self.startLoadingAnimation()
                } else {
                    self.endLoadingAnimation()
                }
            }
            .disposed(by: disposeBag)
            
    }
    
    // MARK: - VoucherTableViewCellDelegate
    func didApplyVoucher(_ voucher: VoucherDataSource) {
        self.acceptance?.accept(voucher)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didCancelVoucher() {
        self.acceptance?.accept(nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listUserVouchers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VoucherTableViewCell(style: .default, reuseIdentifier:"VoucherTableViewCell")
        
        let cellData = viewModel.listUserVouchers.value[indexPath.row]
        cell.setDataSource(cellData)
        cell.delegate = self
        return cell
    }
}
