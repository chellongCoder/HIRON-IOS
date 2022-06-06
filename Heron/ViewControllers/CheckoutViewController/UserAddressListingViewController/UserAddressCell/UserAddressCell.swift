//
//  UserAddressCell.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

protocol UserAddressCellDelegate {
    func didEditAddress(_ address: ContactDataSource)
}

class UserAddressCell: UITableViewCell {
    
    let markAsDefault       = UILabel()
    let fullName            = UILabel()
    let phoneNumber         = UILabel()
    let addressLabel        = UILabel()
    let editButton          = UIButton()
    
    private var contactData : ContactDataSource? = nil
    var delegate            : UserAddressCellDelegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        markAsDefault.isHidden = true
        markAsDefault.text = "Default ✅"
        markAsDefault.font = getFontSize(size: 16, weight: .medium)
        markAsDefault.textColor = kDefaultTextColor
        markAsDefault.textAlignment = .right
        contentView.addSubview(markAsDefault)
        markAsDefault.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        

        fullName.text = "Mike Le"
        fullName.font = getFontSize(size: 14, weight: .medium)
        fullName.textColor = kDefaultTextColor
        contentView.addSubview(fullName)
        fullName.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        phoneNumber.text = "+"
        phoneNumber.font = getFontSize(size: 10, weight: .medium)
        phoneNumber.textColor = kDefaultTextColor
        contentView.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { make in
            make.top.equalTo(fullName.snp.bottom).offset(5)
            make.left.right.equalTo(fullName)
        }
        
        addressLabel.text = "+"
        addressLabel.font = getFontSize(size: 10, weight: .medium)
        addressLabel.textColor = kDefaultTextColor
        addressLabel.numberOfLines = 0
        contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumber.snp.bottom).offset(8)
            make.left.right.equalTo(phoneNumber)
        }
        
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = kPrimaryColor
        editButton.layer.cornerRadius = 8
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: ContactDataSource) {
        
        self.contactData = cellData
        
        self.fullName.text = cellData.firstName + " " + cellData.lastName
        self.phoneNumber.text = cellData.phone
        self.addressLabel.text = cellData.address + "," + cellData.province + "," + cellData.country + "," + cellData.postalCode
        if cellData.isDefault {
            markAsDefault.isHidden = false
        } else {
            markAsDefault.isHidden = true
        }
    }
    
    @objc private func editButtonTapped() {
        guard let contactData = contactData else {
            return
        }

        self.delegate?.didEditAddress(contactData)
    }
}
