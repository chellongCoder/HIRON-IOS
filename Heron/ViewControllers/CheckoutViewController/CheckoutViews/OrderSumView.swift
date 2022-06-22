//
//  OrderSumView.swift
//  Heron
//
//  Created by Luu Luc on 15/06/2022.
//

import UIKit

class OrderSumView: UIView {
    
    var orderSumValue       = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.setShadow()
        
        let orderIcon = UIImageView()
        orderIcon.image = UIImage.init(systemName: "dollarsign.square.fill")
        orderIcon.tintColor = kPrimaryColor
        self.addSubview(orderIcon)
        orderIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.height.width.equalTo(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        let orderSumTitle = UILabel()
        orderSumTitle.text = "Order Sum"
        orderSumTitle.font = getFontSize(size: 14, weight: .medium)
        orderSumTitle.textColor = kDefaultTextColor
        self.addSubview(orderSumTitle)
        orderSumTitle.snp.makeConstraints { make in
            make.centerY.equalTo(orderIcon)
            make.left.equalTo(orderIcon.snp.right).offset(10)
        }
        
        orderSumValue.text = "$0.0"
        orderSumValue.font = getFontSize(size: 14, weight: .bold)
        orderSumValue.textColor = kRedHightLightColor
        self.addSubview(orderSumValue)
        orderSumValue.snp.makeConstraints { make in
            make.centerY.equalTo(orderIcon)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
