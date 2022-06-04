//
//  DeliveryAddressView.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

class AddressView: UIView {
    
    let addressTitle    = UILabel()
    let nextMarkIcon    = UIImageView.init(image: UIImage(systemName: "chevron.right"))
    let contactLabel    = UILabel()
    let addressLabel    = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.setShadow()
        
        let markIcon = UIImageView.init(image: UIImage(systemName: "location"))
        markIcon.tintColor = kPrimaryColor
        self.addSubview(markIcon)
        markIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.height.width.equalTo(20)
        }
        
        addressTitle.text = "Delivery To"
        addressTitle.textColor = kDefaultTextColor
        addressTitle.font = .systemFont(ofSize: 16)
        self.addSubview(addressTitle)
        addressTitle.snp.makeConstraints { make in
            make.centerY.equalTo(markIcon)
            make.left.equalTo(markIcon.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        
        nextMarkIcon.tintColor = kPrimaryColor
        self.addSubview(nextMarkIcon)
        nextMarkIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(20)
        }
        
        contactLabel.numberOfLines = 0
        self.addSubview(contactLabel)
        contactLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        addressLabel.numberOfLines = 0
        self.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(contactLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
