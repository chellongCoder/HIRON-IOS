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
                             UITableViewDataSource, UITableViewDelegate,
                             UITextFieldDelegate, ChipViewVoucherDelegate {
    
    
    let codeTxt         = BoundedIconTextField()
    let applyBtn        = UIButton()
    
    let guidelineView   = UIView()
    let tableView       = UITableView()
    let emptyView       = EmptyView()
    
    private let viewModel   = VoucherViewModel()
    var acceptance          : BehaviorRelay<VoucherDataSource?>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "Voucher Add"
        
        self.showBackBtn()
        
        applyBtn.backgroundColor = kPrimaryColor
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = getCustomFont(size: 13, name: .bold)
        applyBtn.setTitle("Apply", for: .normal)
        applyBtn.layer.cornerRadius = 20
        self.view.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(90)
            make.height.equalTo(40)
        }
        
        codeTxt.delegate = self
        codeTxt.setPlaceHolderText("Heron voucher")
        self.view.addSubview(codeTxt)
        codeTxt.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(10)
            make.right.equalTo(applyBtn.snp.left).offset(-10)
            make.height.equalTo(40)
        }
        
        guidelineView.backgroundColor = UIColor.init(hexString: "f6f6f6")
        self.view.addSubview(guidelineView)
        guidelineView.snp.makeConstraints { make in
            make.top.equalTo(codeTxt.snp.bottom).offset(20)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(37)
        }
        
        let guideLabel = UILabel()
        guideLabel.text = "* You can only choose 1 discount code"
        guideLabel.textColor = kTitleTextColor
        guideLabel.font = getCustomFont(size: 13, name: .italic)
        guidelineView.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        
        var nextView : UIView = guidelineView
        if let selectedVoucher = _CartServices.voucherCode.value {
            
            let addedTitle = UILabel()
            addedTitle.text = "Added"
            addedTitle.textColor = kDefaultTextColor
            addedTitle.font = getCustomFont(size: 13, name: .bold)
            self.view.addSubview(addedTitle)
            addedTitle.snp.makeConstraints { make in
                make.top.equalTo(guidelineView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(16)
            }
            
            let chipView = ChipViewVoucher.init(title: selectedVoucher.couponRule?.title ?? "")
            chipView.delegate = self
            chipView.layer.cornerRadius = 15
            self.view.addSubview(chipView)
            chipView.snp.makeConstraints { make in
                make.top.equalTo(addedTitle.snp.bottom).offset(16)
                make.left.equalToSuperview().offset(16)
                make.height.equalTo(30)
            }
            
            chipView.imageIcon.snp.remakeConstraints { make in
                make.height.width.equalTo(18)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(12)
            }
            
            chipView.textLabel.font = getCustomFont(size: 13, name: .bold)
            
            chipView.clearBtn.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(18)
                make.height.equalToSuperview().offset(-12)
                make.left.equalTo(chipView.textLabel.snp.right).offset(12)
                make.right.equalToSuperview().offset(-6)
            }
            
            nextView = chipView
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(VoucherTableViewCell.self, forCellReuseIdentifier: "VoucherTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(nextView.snp.bottom).offset(20)
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        emptyView.imageView.image = UIImage.init(named: "emptyBox")
        emptyView.messageLabel.text = ""
        emptyView.titleLabel.text = "It seems like there are no voucher available at this moment"
        emptyView.actionButon.isHidden = true
        emptyView.isHidden = true
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.size.equalTo(tableView)
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
            .subscribe { listVouchers in
                
                if (listVouchers.element ?? []).isEmpty {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                    self.tableView.reloadData()
                }
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
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellData = viewModel.listUserVouchers.value[indexPath.row]
        self.acceptance?.accept(cellData)
        self.navigationController?.popViewController(animated: true)
        
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = kPrimaryColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = kLightGrayColor.cgColor
    }
    
    // MARK: - ChipViewVoucherDelegate
    func didSelectClearBtn() {
        _CartServices.voucherCode.accept(nil)
        
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(guidelineView.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let listVoucher = viewModel.listUserVouchers.value
        for voucher in listVoucher {
            voucher.isSelectedVoucher = false
        }
        viewModel.listUserVouchers.accept(listVoucher)
        
        self.tableView.reloadData()
    }
}
