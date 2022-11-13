//
//  BookingProfileTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 08/08/2022.
//

import UIKit

class BookingProfileTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        let patientIcon = UIImageView()
        patientIcon.image = UIImage.init(systemName: "person.circle")
        contentView.addSubview(patientIcon)
        patientIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.height.width.equalTo(27)
        }
        
        let customerTitle = UILabel()
        customerTitle.text = "Customer"
        customerTitle.textColor = kDefaultTextColor
        customerTitle.font = getCustomFont(size: 16, name: .medium)
        contentView.addSubview(customerTitle)
        customerTitle.snp.makeConstraints { make in
            make.centerY.equalTo(patientIcon)
            make.left.equalTo(patientIcon.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        let patientInfo = UILabel()
        patientInfo.textColor = kDefaultTextColor
        patientInfo.font = getCustomFont(size: 16, name: .regular)
        contentView.addSubview(patientInfo)
        patientInfo.snp.makeConstraints { make in
            make.top.equalTo(customerTitle.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
        }
        
        let patientEmail = UILabel()
        patientEmail.textColor = kDefaultTextColor
        patientEmail.font = getCustomFont(size: 16, name: .regular)
        contentView.addSubview(patientEmail)
        patientEmail.snp.makeConstraints { make in
            make.top.equalTo(patientInfo.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        if let profile  = _BookingServices.selectedProfile.value {
            patientInfo.text = String(format: "%@ %@ | %@", profile.firstName, profile.lastName, profile.phone)
            patientEmail.text = profile.email
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
