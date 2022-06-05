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

class VoucherViewController: UIViewController, VoucherTableViewCellDelegate {
    
    let codeTxt         = ErrorTextField()
    let applyBtn        = UIButton()
    
    let tableView       = UITableView()
    
    private let viewModel   = VoucherViewModel()
    private let disposeBag  = DisposeBag()
    var acceptance          : BehaviorRelay<VoucherDataSource?>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Vouchers"
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
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
    
    //MARK: - Buttons
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Data
    func bindingData()
    {
        viewModel.listUserVouchers
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: VoucherDataSource) in
                let cell = VoucherTableViewCell(style: .default, reuseIdentifier:"VoucherTableViewCell")
                cell.setDataSource(element)
                cell.delegate = self
                return cell
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
    
    //MARK: - VoucherTableViewCellDelegate
    func didApplyVoucher(_ voucher: VoucherDataSource) {
        self.acceptance?.accept(voucher)
        self.navigationController?.popViewController(animated: true)
    }
}
