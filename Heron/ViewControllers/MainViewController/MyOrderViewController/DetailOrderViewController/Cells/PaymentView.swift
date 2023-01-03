//
//  PaymentTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//

import UIKit

class PaymentView: UIView {
    
    let paymentCardLabel     = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        
        let contentView = UIView()
        self.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview()
        }
        
        let line = UIView()
        line.backgroundColor = kGrayColor
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(6)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(contentView.snp.top)
        }
        
        let orderInfoLabel = UILabel()
        orderInfoLabel.text = "Order infomation"
        orderInfoLabel.textColor = kDefaultTextColor
        orderInfoLabel.font = getCustomFont(size: 13, name: .bold)
        contentView.addSubview(orderInfoLabel)
        orderInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        let orderIdLabel = UILabel()
        orderIdLabel.text = "Order ID"
        orderIdLabel.textColor = kDefaultTextColor
        orderIdLabel.font = getCustomFont(size: 11, name: .regular)
        contentView.addSubview(orderIdLabel)
        orderIdLabel.snp.makeConstraints { make in
            make.top.equalTo(orderInfoLabel.snp.bottom).offset(12)
            make.left.equalTo(orderInfoLabel)
        }
        
        let orderIdValue = UILabel()
        orderIdValue.text = "#1234567889"
        orderIdValue.font = getCustomFont(size: 13, name: .semiBold)
        orderIdValue.textColor = kPrimaryColor
        contentView.addSubview(orderIdValue)
        orderIdValue.snp.makeConstraints { make in
            make.top.equalTo(orderIdLabel.snp.bottom).offset(8)
            make.left.equalTo(orderIdLabel)
        }
        
        let copyTitle = UILabel()
        copyTitle.text = "Copy"
        copyTitle.font = getCustomFont(size: 11, name: .regular)
        copyTitle.textColor = kCustomTextColor
        contentView.addSubview(copyTitle)
        copyTitle.snp.makeConstraints { make in
            make.top.equalTo(orderIdValue)
            make.right.equalToSuperview().offset(-16)
        }
        
        let copyBtn = UIButton()
        copyBtn.setImage(UIImage.init(named: "copy_icon"), for: .normal)
        contentView.addSubview(copyBtn)
        copyBtn.snp.makeConstraints { make in
            make.top.equalTo(orderIdValue)
            make.right.equalTo(copyTitle.snp.left).offset(-7)
            make.height.width.equalTo(16)
        }
        
        let orderDateLabel = UILabel()
        orderDateLabel.text = "Order date"
        orderDateLabel.font = getCustomFont(size: 11, name: .regular)
        orderDateLabel.textColor = kDefaultTextColor
        contentView.addSubview(orderDateLabel)
        orderDateLabel.snp.makeConstraints { make in
            make.top.equalTo(orderIdValue.snp.bottom).offset(16)
            make.left.equalTo(orderInfoLabel)
        }
        
        let orderDateValue = UILabel()
        orderDateValue.text = "Feb 05, 2022"
        orderDateValue.font = getCustomFont(size: 13, name: .semiBold)
        orderDateValue.textColor = kDefaultTextColor
        contentView.addSubview(orderDateValue)
        orderDateValue.snp.makeConstraints { make in
            make.top.equalTo(orderDateLabel.snp.bottom).offset(8)
            make.left.equalTo(orderInfoLabel)
        }
        
        let shippingMethodLabel = UILabel()
        shippingMethodLabel.text = "Shipping method"
        shippingMethodLabel.font = getCustomFont(size: 11, name: .regular)
        shippingMethodLabel.textColor = kDefaultTextColor
        contentView.addSubview(shippingMethodLabel)
        shippingMethodLabel.snp.makeConstraints { make in
            make.top.equalTo(orderDateValue.snp.bottom).offset(16)
            make.left.equalTo(orderInfoLabel)
        }
        
        let shippingMethodValue = UILabel()
        shippingMethodValue.text = "Standard delivery"
        shippingMethodValue.font = getCustomFont(size: 13, name: .semiBold)
        shippingMethodValue.textColor = kDefaultTextColor
        contentView.addSubview(shippingMethodValue)
        shippingMethodValue.snp.makeConstraints { make in
            make.top.equalTo(shippingMethodLabel.snp.bottom).offset(8)
            make.left.equalTo(orderInfoLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
