//
//  CarierView.swift
//  Heron
//
//  Created by Luu Luc on 15/06/2022.
//

import UIKit

class CarrierView: UIView {
    
    let carrierName     = UILabel()
    let nextMarkIcon    = UIImageView.init(image: UIImage(systemName: "chevron.right"))
    let shippingFee     = UILabel()
    let receivedLog    = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.setShadow()
        
        let carrierTitle = UILabel()
        carrierTitle.text = "Carrier"
        carrierTitle.textColor = kDefaultTextColor
        carrierTitle.font = getFontSize(size: 14, weight: .medium)
        self.addSubview(carrierTitle)
        carrierTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        carrierName.text = "Grab"
        carrierName.textColor = kDefaultTextColor
        carrierName.font = getFontSize(size: 12, weight: .regular)
        self.addSubview(carrierName)
        carrierName.snp.makeConstraints { make in
            make.top.equalTo(carrierTitle.snp.bottom)
            make.centerX.equalTo(carrierTitle)
            make.left.greaterThanOrEqualTo(carrierTitle)
        }
        
        nextMarkIcon.tintColor = kPrimaryColor
        self.addSubview(nextMarkIcon)
        nextMarkIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(20)
        }
        
        shippingFee.text = "$0.0"
        shippingFee.textAlignment = .right
        shippingFee.font = getFontSize(size: 14, weight: .regular)
        self.addSubview(shippingFee)
        shippingFee.snp.makeConstraints { make in
            make.centerY.equalTo(nextMarkIcon)
            make.right.equalTo(nextMarkIcon.snp.left).offset(-10)
        }
        
        let profileIcon = UIImageView()
        profileIcon.image = UIImage(systemName: "folder.fill.badge.person.crop")
        profileIcon.tintColor = kPrimaryColor
        self.addSubview(profileIcon)
        profileIcon.snp.makeConstraints { make in
            make.top.equalTo(carrierName.snp.bottom).offset(10)
            make.left.equalTo(carrierTitle)
            make.height.width.equalTo(20)
        }
        
        receivedLog.text = "Received order on "
        receivedLog.textColor = UIColor.init(hexString: "444444")
        receivedLog.font = getFontSize(size: 12, weight: .medium)
        self.addSubview(receivedLog)
        receivedLog.snp.makeConstraints { make in
            make.centerY.equalTo(profileIcon)
            make.left.equalTo(profileIcon.snp.right).offset(10)
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
