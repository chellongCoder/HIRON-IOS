//
//  VoucherSelectedView.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

class VoucherSelectedView: UIView {
    
    let voucherTitle    = UILabel()
    let voucherCode     = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.setShadow()
        
        voucherTitle.text = "Voucher"
        voucherTitle.textColor = kDefaultTextColor
        voucherTitle.font = .boldSystemFont(ofSize: 14)
        self.addSubview(voucherTitle)
        voucherTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(14)
            make.bottom.lessThanOrEqualToSuperview().offset(-13)
        }
        
        voucherCode.text = " SALE 0% "
        voucherCode.layer.borderColor = kRedHightLightColor.cgColor
        voucherCode.layer.borderWidth = 1
        voucherCode.textColor = kRedHightLightColor
        self.addSubview(voucherCode)
        voucherCode.snp.makeConstraints { make in
            make.centerY.equalTo(voucherTitle)
            make.height.equalTo(voucherTitle).offset(10)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
