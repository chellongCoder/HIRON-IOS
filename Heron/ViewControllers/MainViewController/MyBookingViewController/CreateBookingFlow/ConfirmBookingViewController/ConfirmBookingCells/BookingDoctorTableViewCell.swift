//
//  BookingDoctorTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 08/08/2022.
//

import UIKit

class BookingDoctorTableViewCell: UITableViewCell {

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
        
        let doctorIcon = UIImageView()
        doctorIcon.image = UIImage.init(systemName: "heart.text.square")
        contentView.addSubview(doctorIcon)
        doctorIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.height.width.equalTo(27)
        }
        
        let doctorInforName = UILabel()
        doctorInforName.text = "Mr Mike Lee"
        doctorInforName.textColor = kDefaultTextColor
        doctorInforName.font = getFontSize(size: 16, weight: .medium)
        contentView.addSubview(doctorInforName)
        doctorInforName.snp.makeConstraints { make in
            make.centerY.equalTo(doctorIcon)
            make.left.equalTo(doctorIcon.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        let doctorInfoTags = UILabel()
        doctorInfoTags.textColor = kDefaultTextColor
        doctorInfoTags.font = getFontSize(size: 16, weight: .regular)
        contentView.addSubview(doctorInfoTags)
        doctorInfoTags.snp.makeConstraints { make in
            make.top.equalTo(doctorInforName.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
        }
        
        let doctorInfoDean = UILabel()
        doctorInfoDean.textColor = kDefaultTextColor
        doctorInfoDean.font = getFontSize(size: 16, weight: .regular)
        contentView.addSubview(doctorInfoDean)
        doctorInfoDean.snp.makeConstraints { make in
            make.top.equalTo(doctorInfoTags.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        if let selectedDoctor = _BookingServices.selectedDoctor.value {
            doctorInforName.text = String(format: "%@ %@", selectedDoctor.user?.firstName ?? "", selectedDoctor.user?.lastName ?? "")
            
            var tagContentStr = ""
            for teamMemberPosition in selectedDoctor.teamMemberPosition {
                if let deparment = teamMemberPosition.team?.department {
                    tagContentStr = deparment.name
                }
            }
            
            if let expAtribute = selectedDoctor.attributeValues.first(where: { doctorAttribute in
                return doctorAttribute.attributeCode == .Experience
            }) {
                tagContentStr = String(format: "%@ | %@", tagContentStr, expAtribute.value)
            }
            
            doctorInfoTags.text = tagContentStr
            
            if let deanAtribute = selectedDoctor.attributeValues.first(where: { doctorAttribute in
                return doctorAttribute.attributeCode == .Dean
            }) {
                doctorInfoDean.text = deanAtribute.value
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
