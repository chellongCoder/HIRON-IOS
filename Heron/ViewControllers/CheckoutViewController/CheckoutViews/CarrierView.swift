//
//  CarierView.swift
//  Heron
//
//  Created by Luu Luc on 15/06/2022.
//

import UIKit

class CarrierView: UIView {
    
    let carrierName     = UILabel()
    let nextMarkIcon    = UIImageView.init(image: UIImage(named: "right_icon"))
    let receivedLog     = UILabel()
    let priceLabel      = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let profileIcon = UIImageView()
        profileIcon.image = UIImage(named: "radio_active_btn")
        profileIcon.tintColor = kPrimaryColor
        self.addSubview(profileIcon)
        profileIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14.5)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(16)
        }
        
        carrierName.text = "Grab"
        carrierName.textColor = kDefaultTextColor
        carrierName.font = getCustomFont(size: 13, name: .regular)
        self.addSubview(carrierName)
        carrierName.snp.makeConstraints { make in
            make.centerY.equalTo(profileIcon.snp.centerY)
            make.left.equalTo(profileIcon.snp.right).offset(12)
        }
        
        receivedLog.text = "Receive order on "
        receivedLog.textColor = kDefaultTextColor
        receivedLog.font = getCustomFont(size: 11, name: .regular)
        self.addSubview(receivedLog)
        receivedLog.snp.makeConstraints { make in
            make.left.equalTo(carrierName.snp.left)
            make.top.equalTo(carrierName.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        priceLabel.text = "$10.00"
        priceLabel.textColor = kDefaultTextColor
        priceLabel.font = getCustomFont(size: 13, name: .semiBold)
        priceLabel.textAlignment = .right
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(carrierName.snp.centerY)
            make.right.equalToSuperview().offset(-16)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
