//
//  MyAppoitmentTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit

class MyBookingTableViewCell: UITableViewCell {

    let bookingStatusLabel  = UILabel()
    let storeNameLabel      = UILabel()
    let timeableLabel       = UILabel()
    let addressBookingLabel = UILabel()
    let patientInfoLabel    = UILabel()
//    let doctorInfoLabel     = UILabel()
    let totalPaymentLabel   = UILabel()
    let bookingIDLabel      = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        storeNameLabel.text = "HARD_CODE"
        storeNameLabel.textColor = kDefaultTextColor
        storeNameLabel.font = getFontSize(size: 16, weight: .bold)
        contentView.addSubview(storeNameLabel)
        storeNameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        bookingStatusLabel.text = " HARD_CODE "
        bookingStatusLabel.textColor = kPrimaryColor
        bookingStatusLabel.font = getFontSize(size: 14, weight: .regular)
        bookingStatusLabel.layer.borderWidth = 1
        bookingStatusLabel.layer.borderColor = kPrimaryColor.cgColor
        contentView.addSubview(bookingStatusLabel)
        self.bookingStatusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(20)
        }
        
        let timeableIcon = UIImageView()
        timeableIcon.image = UIImage.init(systemName: "timer")
        timeableIcon.tintColor = kDefaultTextColor
        contentView.addSubview(timeableIcon)
        timeableIcon.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(8)
            make.left.equalTo(storeNameLabel)
            make.height.width.equalTo(13)
        }
        
        timeableLabel.text = "HARD_CODE"
        timeableLabel.textColor = kDefaultTextColor
        timeableLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(timeableLabel)
        timeableLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let addressIcon = UIImageView()
        addressIcon.image = UIImage.init(systemName: "location")
        addressIcon.tintColor = kDefaultTextColor
        contentView.addSubview(addressIcon)
        addressIcon.snp.makeConstraints { make in
            make.top.equalTo(timeableIcon.snp.bottom).offset(8)
            make.left.equalTo(storeNameLabel)
            make.height.width.equalTo(13)
        }
        
        addressBookingLabel.text = "HARD_CODE"
        addressBookingLabel.numberOfLines = 0
        addressBookingLabel.textColor = kDefaultTextColor
        addressBookingLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(addressBookingLabel)
        addressBookingLabel.snp.makeConstraints { make in
            make.top.equalTo(timeableLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let patientIcon = UIImageView()
        patientIcon.image = UIImage.init(systemName: "person")
        patientIcon.tintColor = kDefaultTextColor
        contentView.addSubview(patientIcon)
        patientIcon.snp.makeConstraints { make in
            make.top.equalTo(addressBookingLabel.snp.bottom).offset(8)
            make.left.equalTo(storeNameLabel)
            make.height.width.equalTo(13)
        }
        
        patientInfoLabel.text = "HARD_CODE"
        patientInfoLabel.numberOfLines = 0
        patientInfoLabel.textColor = kDefaultTextColor
        patientInfoLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(patientInfoLabel)
        patientInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(addressBookingLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
//        let doctorIcon = UIImageView()
//        doctorIcon.image = UIImage.init(systemName: "person.badge.plus")
//        doctorIcon.tintColor = kDefaultTextColor
//        contentView.addSubview(doctorIcon)
//        doctorIcon.snp.makeConstraints { make in
//            make.top.equalTo(patientInfoLabel.snp.bottom).offset(8)
//            make.left.equalTo(titleLabel)
//            make.height.width.equalTo(13)
//        }
//
//        doctorInfoLabel.text = "HARD_CODE"
//        doctorInfoLabel.numberOfLines = 0
//        doctorInfoLabel.textColor = kDefaultTextColor
//        doctorInfoLabel.font = getFontSize(size: 14, weight: .regular)
//        contentView.addSubview(doctorInfoLabel)
//        doctorInfoLabel.snp.makeConstraints { make in
//            make.top.equalTo(patientInfoLabel.snp.bottom).offset(8)
//            make.left.equalTo(timeableIcon.snp.right).offset(8)
//            make.right.equalToSuperview().offset(-16)
//        }
        
        let paymentIcon = UIImageView()
        paymentIcon.image = UIImage.init(systemName: "creditcard")
        paymentIcon.tintColor = kDefaultTextColor
        contentView.addSubview(paymentIcon)
        paymentIcon.snp.makeConstraints { make in
            make.top.equalTo(patientInfoLabel.snp.bottom).offset(8)
            make.left.equalTo(storeNameLabel)
            make.height.width.equalTo(13)
        }
        
        totalPaymentLabel.text = "HARD_CODE"
        totalPaymentLabel.numberOfLines = 0
        totalPaymentLabel.textColor = kDefaultTextColor
        totalPaymentLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(totalPaymentLabel)
        totalPaymentLabel.snp.makeConstraints { make in
            make.top.equalTo(patientInfoLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let bookingIDIcon = UIImageView()
        bookingIDIcon.image = UIImage.init(systemName: "calendar")
        bookingIDIcon.tintColor = kDefaultTextColor
        contentView.addSubview(bookingIDIcon)
        bookingIDIcon.snp.makeConstraints { make in
            make.top.equalTo(totalPaymentLabel.snp.bottom).offset(8)
            make.left.equalTo(storeNameLabel)
            make.height.width.equalTo(13)
        }
        
        bookingIDLabel.text = "HARD_CODE"
        bookingIDLabel.numberOfLines = 0
        bookingIDLabel.textColor = kDefaultTextColor
        bookingIDLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(bookingIDLabel)
        bookingIDLabel.snp.makeConstraints { make in
            make.top.equalTo(totalPaymentLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ data: BookingAppointmentDataSource) {
        
        self.storeNameLabel.text = data.store?.name
        self.addressBookingLabel.text = data.store?.addressInfo?.getAddressString()
        
        self.bookingStatusLabel.text = String(format: " %@ ", data.getStatusLabel())
        
        let startTime = Date.init(timeIntervalSince1970: TimeInterval(data.startTime/1000))
        let endTime = Date.init(timeIntervalSince1970: TimeInterval(data.endTime/1000))
        self.timeableLabel.text = String(format: "From: %@ - To: %@. At %@",
                                         startTime.toString(dateFormat: "HH:mm"),
                                         endTime.toString(dateFormat: "HH:mm"),
                                         endTime.toString(dateFormat: "MMM dd, yyyy"))
        
        self.patientInfoLabel.text = String(format: "Customer: %@ %@ | Gender: %@",
                                            data.profile?.firstName ?? "",
                                            data.profile?.lastName ?? "",
                                            data.profile?.gender == .male ? "Male" : "Female")
        self.totalPaymentLabel.text = String(format: "Total: %@",
                                             getMoneyFormat(data.customAmount))
        self.bookingIDLabel.text = String(format: " BookingID: #%@",
                                          data.code)
    }
}
