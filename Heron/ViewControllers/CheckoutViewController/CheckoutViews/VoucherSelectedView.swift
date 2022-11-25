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
