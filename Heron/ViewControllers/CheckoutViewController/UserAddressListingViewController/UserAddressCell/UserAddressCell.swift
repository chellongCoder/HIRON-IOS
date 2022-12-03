//
//  UserAddressCell.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

protocol UserAddressCellDelegate : AnyObject {
    func didEditAddress(_ address: ContactDataSource)
}

class UserAddressCell: UITableViewCell {
    
    let markAsDefault       = ChipView(title: "")
    let fullName            = UILabel()
    let phoneNumber         = UILabel()
    let addressLabel        = UILabel()
    let editButton          = UIButton()
    let seleteButton        = UIButton()
    
    private var contactData : ContactDataSource?
    var delegate            : UserAddressCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        
        seleteButton.setBackgroundImage(UIImage.init(named: "radio_inactive_btn"), for: .normal)
        seleteButton.setBackgroundImage(UIImage.init(named: "radio_active_btn"), for: .selected)
        seleteButton.addTarget(self, action: #selector(seleteButtonTapped), for: .touchUpInside)
        contentView.addSubview(seleteButton)
        seleteButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.height.width.equalTo(16)
        }
        
        fullName.text = "Mike Le"
        fullName.font = getCustomFont(size: 13, name: .bold)
        fullName.textColor = kTitleTextColor
        contentView.addSubview(fullName)
        fullName.snp.makeConstraints { (make) in
            make.left.equalTo(seleteButton.snp.right).offset(2)
            make.centerY.equalTo(seleteButton.snp.centerY)
        }
        
        phoneNumber.text = "+"
        phoneNumber.font = getCustomFont(size: 10, name: .medium)
        phoneNumber.textColor = kTitleTextColor
        contentView.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { make in
            make.top.equalTo(fullName.snp.bottom).offset(5)
            make.left.right.equalTo(fullName)
        }
        
        addressLabel.text = "+"
        addressLabel.font = getCustomFont(size: 10, name: .medium)
        addressLabel.textColor = kTitleTextColor
        addressLabel.numberOfLines = 0
        contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumber.snp.bottom).offset(8)
            make.left.right.equalTo(phoneNumber)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        editButton.setBackgroundImage(UIImage.init(named: "edit_icon"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullName.snp.centerY)
            make.right.equalToSuperview().offset(-14)
            make.height.width.equalTo(14)
        }
        
        markAsDefault.isHidden = true
        markAsDefault.textLabel.text = " Default "
        markAsDefault.textLabel.textColor = kCustomTextColor
        markAsDefault.layer.cornerRadius = 9
        contentView.addSubview(markAsDefault)
        markAsDefault.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(19)
            make.left.equalTo(addressLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        let line = UIView()
        line.backgroundColor = kGrayColor
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(6)
            make.centerX.width.equalToSuperview()
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
    
    @objc private func seleteButtonTapped() {
        seleteButton.isSelected = !seleteButton.isSelected
    }
}
