//
//  VoucherViewController.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import Material

class VoucherViewController: UIViewController {
    
    let codeTxt         = ErrorTextField()
    let applyBtn        = UIButton()
    
    let tableView       = UITableView()
    
    private let viewModel   = VoucherViewModel()
    private let disposeBag  = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Vouchers"
        
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
    }
}
