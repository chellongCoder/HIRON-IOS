//
//  BookingInfoTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 08/08/2022.
//

import UIKit
import SkeletonView

class BookingInfoTableViewCell: UITableViewCell {

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
        
        let infoIcon = UIImageView()
        infoIcon.image = UIImage.init(systemName: "info.circle")
        contentView.addSubview(infoIcon)
        infoIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.height.width.equalTo(27)
        }
        
        let bookingInfoTitle = UILabel()
        bookingInfoTitle.text = "Booking Information"
        bookingInfoTitle.textColor = kDefaultTextColor
        bookingInfoTitle.font = getCustomFont(size: 16, name: .medium)
        contentView.addSubview(bookingInfoTitle)
        bookingInfoTitle.snp.makeConstraints { make in
            make.centerY.equalTo(infoIcon)
            make.left.equalTo(infoIcon.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        let bookingInfoDate = UILabel()
        bookingInfoDate.textColor = kDefaultTextColor
        bookingInfoDate.font = getCustomFont(size: 16, name: .regular)
        contentView.addSubview(bookingInfoDate)
        bookingInfoDate.snp.makeConstraints { make in
            make.top.equalTo(bookingInfoTitle.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
        }
        
        let bookingInfoTime = UILabel()
        bookingInfoTime.textColor = kDefaultTextColor
        bookingInfoTime.font = getCustomFont(size: 16, name: .regular)
        contentView.addSubview(bookingInfoTime)
        bookingInfoTime.snp.makeConstraints { make in
            make.top.equalTo(bookingInfoDate.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
        }
        
        let bookingInfoLocations = UILabel()
        bookingInfoLocations.text = String(format: "Location: ")
        bookingInfoLocations.textColor = kDefaultTextColor
        bookingInfoLocations.font = getCustomFont(size: 16, name: .regular)
        bookingInfoLocations.numberOfLines = 0
        contentView.addSubview(bookingInfoLocations)
        bookingInfoLocations.snp.makeConstraints { make in
            make.top.equalTo(bookingInfoTime.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        if let selectedTime = _BookingServices.selectedTimeable.value {
            let startTimeInterval = TimeInterval(selectedTime.startTime/1000)
            let startTime = Date.init(timeIntervalSince1970: startTimeInterval)
            
            let endTimeInterval = TimeInterval(selectedTime.endTime/1000)
            let endTime = Date.init(timeIntervalSince1970: endTimeInterval)
            
            bookingInfoDate.text = String(format: "Date: %@", startTime.toString(dateFormat: "MMM dd, yyyy"))
            bookingInfoTime.text = String(format: "Time: %@ - %@", startTime.toString(dateFormat: "HH:mm"), endTime.toString(dateFormat: "HH:mm"))
        }
        
        if let storeDataSource = _BookingServices.storeDataSource.value {
            bookingInfoLocations.text = String(format: "Location: %@", storeDataSource.addressInfo?.getAddressString() ?? "")

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
