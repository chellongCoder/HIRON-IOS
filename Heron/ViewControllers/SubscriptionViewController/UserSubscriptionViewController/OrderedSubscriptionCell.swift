//
//  OrderedSubscriptionCell.swift
//  Heron
//
//  Created by Luu Luc on 28/08/2022.
//

import UIKit

class OrderedSubscriptionCell: UITableViewCell {
    
    let orderCreatedAtLabel = UILabel()
    let amountLabel         = UILabel()
    let subsNameLabel       = UILabel()
    let orderNumberLabel    = UILabel()
    
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
        
        let subscriptionIcon = UIImageView()
        subscriptionIcon.image = UIImage.init(systemName: "list.bullet.rectangle")
        contentView.addSubview(subscriptionIcon)
        subscriptionIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.left.equalToSuperview().offset(30)
            make.width.equalTo(55)
            make.height.equalTo(43)
        }
        
        orderCreatedAtLabel.textColor = kDefaultTextColor
        orderCreatedAtLabel.font = getFontSize(size: 16, weight: .medium)
        orderCreatedAtLabel.numberOfLines = 0
        contentView.addSubview(orderCreatedAtLabel)
        orderCreatedAtLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(subscriptionIcon.snp.right).offset(22)
            make.right.equalToSuperview().offset(-16)
        }
        
        amountLabel.textColor = kDefaultTextColor
        amountLabel.font = getFontSize(size: 14, weight: .regular)
        amountLabel.numberOfLines = 0
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(orderCreatedAtLabel.snp.bottom).offset(10)
            make.left.equalTo(subscriptionIcon.snp.right).offset(22)
            make.right.equalToSuperview().offset(-16)
        }
        
        subsNameLabel.textColor = kDefaultTextColor
        subsNameLabel.font = getFontSize(size: 14, weight: .regular)
        subsNameLabel.numberOfLines = 0
        contentView.addSubview(subsNameLabel)
        subsNameLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(10)
            make.left.equalTo(subscriptionIcon.snp.right).offset(22)
            make.right.equalToSuperview().offset(-16)
        }
        
        orderNumberLabel.textColor = kDefaultTextColor
        orderNumberLabel.font = getFontSize(size: 14, weight: .medium)
        orderNumberLabel.numberOfLines = 0
        contentView.addSubview(orderNumberLabel)
        orderNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(subsNameLabel.snp.bottom).offset(10)
            make.left.equalTo(subscriptionIcon.snp.right).offset(22)
            make.right.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ data: UserRegisteredSubscription) {
        let createdDate = Date.init(timeIntervalSince1970: TimeInterval(data.enabledAt)/1000)
        self.orderCreatedAtLabel.text = String(format: "Ordered on %@", createdDate.toString(dateFormat: "MMM dd yyyy"))
        
        self.amountLabel.text = String(format: "Amount %@", getMoneyFormat(data.subsPlan?.customFinalPrice))
        
        self.subsNameLabel.text = String(format: "Type: %@", data.subsPlan?.subsItem?.name ?? "")
        
        self.orderNumberLabel.text = String(format: "Order #%@", data.code)
    }
}
