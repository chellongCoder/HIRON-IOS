//
//  BookingPaymentTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 08/08/2022.
//

import UIKit

class BookingPaymentTableViewCell: UITableViewCell {

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
        
        let creditIcon = UIImageView()
        creditIcon.image = UIImage.init(systemName: "creditcard")
        contentView.addSubview(creditIcon)
        creditIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.height.width.equalTo(27)
        }
        
        let paymentMethodTitle = UILabel()
        paymentMethodTitle.text = "Payment method"
        paymentMethodTitle.textColor = kDefaultTextColor
        paymentMethodTitle.font = getCustomFont(size: 16, name: .medium)
        contentView.addSubview(paymentMethodTitle)
        paymentMethodTitle.snp.makeConstraints { make in
            make.centerY.equalTo(creditIcon)
            make.left.equalTo(creditIcon.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        let paymentCardType = UILabel()
        paymentCardType.text = "HARD_CODE: Credit / Debit card"
        paymentCardType.textColor = kDefaultTextColor
        paymentCardType.font = getCustomFont(size: 16, name: .regular)
        contentView.addSubview(paymentCardType)
        paymentCardType.snp.makeConstraints { make in
            make.top.equalTo(paymentMethodTitle.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
        }
        
        let creditCardNum = UILabel()
        creditCardNum.text = "HARD_CODE: *1234"
        creditCardNum.textColor = kDefaultTextColor
        creditCardNum.font = getCustomFont(size: 16, name: .regular)
        contentView.addSubview(creditCardNum)
        creditCardNum.snp.makeConstraints { make in
            make.top.equalTo(paymentCardType.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
