//
//  DeliveryAddressView.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

class AddressView: UIView {
    
    let addressTitle    = UILabel()
    let contactLabel    = UILabel()
    let addressLabel    = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.init(hexString: "f6f6f6")
        
        let markIcon = UIImageView.init(image: UIImage(named: "location_icon"))
        markIcon.contentMode = .scaleAspectFit
        markIcon.tintColor = kPrimaryColor
        self.addSubview(markIcon)
        markIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
            make.left.equalToSuperview().offset(16)
        }
        
        let nextMarkIcon = UIImageView.init(image: UIImage(named: "edit_icon"))
        markIcon.contentMode = .scaleAspectFit
        self.addSubview(nextMarkIcon)
        nextMarkIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(16)
        }
        
        addressTitle.text = "Shipping infomation"
        addressTitle.textColor = kTitleTextColor
        addressTitle.font = getCustomFont(size: 13, name: .bold)
        self.addSubview(addressTitle)
        addressTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(markIcon.snp.right).offset(12)
            make.right.equalTo(nextMarkIcon.snp.left).offset(-12)
        }
                
        contactLabel.numberOfLines = 0
        contactLabel.font = getCustomFont(size: 13, name: .medium)
        contactLabel.textColor = kTitleTextColor
        self.addSubview(contactLabel)
        contactLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTitle.snp.bottom).offset(12)
            make.left.equalTo(markIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
        
        addressLabel.numberOfLines = 0
        addressLabel.font = getCustomFont(size: 13, name: .medium)
        contactLabel.textColor = kTitleTextColor
        self.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(contactLabel.snp.bottom).offset(12)
            make.left.equalTo(markIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
