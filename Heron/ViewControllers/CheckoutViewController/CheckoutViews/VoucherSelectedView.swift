//
//  VoucherSelectedView.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

protocol VoucherSelectedViewDelegate {
    func didSelectClearBtn()
}

class VoucherSelectedView: UIView, ChipViewVoucherDelegate {
    
    let voucherTitle    = UILabel()
    let voucherCode     = ChipViewVoucher.init(title: "")
    
    var delegate        : VoucherSelectedViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let voucherIcon = UIImageView()
        voucherIcon.image = UIImage.init(named: "voucher_icon")
        voucherIcon.contentMode = .scaleAspectFit
        self.addSubview(voucherIcon)
        voucherIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        voucherTitle.text = "Voucher"
        voucherTitle.textColor = kDefaultTextColor
        voucherTitle.font = getCustomFont(size: 13, name: .regular)
        self.addSubview(voucherTitle)
        voucherTitle.snp.makeConstraints { make in
            make.centerY.equalTo(voucherIcon)
            make.left.equalTo(voucherIcon.snp.right).offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-13)
        }
        
        let nextIcon = UIImageView()
        nextIcon.image = UIImage.init(named: "right_icon")
        self.addSubview(nextIcon)
        nextIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        voucherCode.delegate = self
        voucherCode.textLabel.text = ""
        self.addSubview(voucherCode)
        voucherCode.snp.makeConstraints { make in
            make.centerY.equalTo(voucherTitle)
            make.right.equalTo(nextIcon.snp.left).offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVoucherData(_ voucherDataSource: VoucherDataSource?) {
        guard let voucherDataSource = voucherDataSource else {
            self.voucherCode.isHidden = true
            self.voucherCode.textLabel.text = "".uppercased()
            return
        }
        
        self.voucherCode.isHidden = false
        
        if voucherDataSource.couponRule?.isFixed ?? false {
            // discount value
            self.voucherCode.textLabel.text = String(format: " %@ ", getMoneyFormat(voucherDataSource.couponRule?.customDiscount)).uppercased()
            
        } else {
            // discout percent
            self.voucherCode.textLabel.text = String(format: " %ld%% OFF ", voucherDataSource.couponRule?.discount ?? 0).uppercased()
        }
    }
    
    //MARK: - ChipViewVoucherDelegate
    func didSelectClearBtn() {
        delegate?.didSelectClearBtn()
    }
}
