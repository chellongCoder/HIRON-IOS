//
//  OrderTotalView.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

class OrderTotalView: UIView {
    
    private let title       = UILabel()
    let subtotalLabel       = UILabel()
    let subTotalValue       = UILabel()
    let discountLabel       = UILabel()
    let discountValue       = UILabel()
    let shippingAndTaxLabel = UILabel()
    let shippingAndTaxValue = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        subtotalLabel.text = "Sub total"
        subtotalLabel.textAlignment = .left
        subtotalLabel.font = getCustomFont(size: 13, name: .light)
        subtotalLabel.textColor = kTitleTextColor
        self.addSubview(subtotalLabel)
        subtotalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        subTotalValue.text = "$0"
        subTotalValue.textAlignment = .right
        subTotalValue.font = getCustomFont(size: 13, name: .semiBold)
        subTotalValue.textColor = kTitleTextColor
        self.addSubview(subTotalValue)
        subTotalValue.snp.makeConstraints { make in
            make.centerY.equalTo(subtotalLabel.snp.centerY)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        discountLabel.text = "Voucher's discount"
        discountLabel.textAlignment = .left
        discountLabel.font = getCustomFont(size: 13, name: .light)
        discountLabel.textColor = kTitleTextColor
        self.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { make in
            make.top.equalTo(subTotalValue.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        discountValue.text = "$0"
        discountValue.textAlignment = .right
        discountValue.font = getCustomFont(size: 13, name: .semiBold)
        discountValue.textColor = kTitleTextColor
        self.addSubview(discountValue)
        discountValue.snp.makeConstraints { make in
            make.centerY.equalTo(discountLabel.snp.centerY)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        shippingAndTaxLabel.text = "Shipping and Tax"
        shippingAndTaxLabel.textAlignment = .left
        shippingAndTaxLabel.font = getCustomFont(size: 13, name: .light)
        shippingAndTaxLabel.textColor = kTitleTextColor
        self.addSubview(shippingAndTaxLabel)
        shippingAndTaxLabel.snp.makeConstraints { make in
            make.top.equalTo(discountValue.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        shippingAndTaxValue.text = "$0"
        shippingAndTaxValue.textAlignment = .right
        shippingAndTaxValue.font = getCustomFont(size: 13, name: .semiBold)
        shippingAndTaxValue.textColor = kTitleTextColor
        self.addSubview(shippingAndTaxValue)
        shippingAndTaxValue.snp.makeConstraints { make in
            make.centerY.equalTo(shippingAndTaxLabel.snp.centerY)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
