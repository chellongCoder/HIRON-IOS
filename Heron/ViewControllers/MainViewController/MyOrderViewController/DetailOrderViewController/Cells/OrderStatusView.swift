//
//  ProductStatusTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//

import RxSwift
import UIKit

class OrderStatusView: UIView {
    
    private let statusLabel = UILabel()
    private let descStatusLabel = UILabel()
    private let orderDetailLabel = UILabel()
    private let purchasedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.094, green: 0.565, blue: 1, alpha: 0.05)
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        statusLabel.text = "Prepare product to you"
        statusLabel.textColor = kPrimaryColor
        statusLabel.font = getCustomFont(size: 18, name: .bold)
        statusLabel.font = .boldSystemFont(ofSize: 18)
        self.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        descStatusLabel.text = "You will receive the order on Feb 05, 2021. Please keep your phone to get calls from the shipper"
        descStatusLabel.font = getCustomFont(size: 14, name: .regular)
        descStatusLabel.textColor = kDefaultTextColor
        descStatusLabel.numberOfLines = 0
        self.addSubview(descStatusLabel)
        descStatusLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(statusLabel.snp.bottom).offset(10)
        }
        
        let orderIdLabel = UILabel()
        orderIdLabel.text = "Order ID"
        orderIdLabel.font = getCustomFont(size: 14, name: .medium)
        self.addSubview(orderIdLabel)
        orderIdLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(descStatusLabel.snp.bottom).offset(10)
        }
        
        let purchasedId = UILabel()
        purchasedId.text = "Purchased date"
        purchasedId.font = getCustomFont(size: 14, name: .medium)
        self.addSubview(purchasedId)
        purchasedId.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(orderIdLabel.snp.bottom).offset(10)
        }
        
        orderDetailLabel.text = "ORD1234567891CD"
        orderDetailLabel.font = getCustomFont(size: 14, name: .regular)
        self.addSubview(orderDetailLabel)
        orderDetailLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(descStatusLabel.snp.bottom).offset(10)
        }
        
        purchasedLabel.text = "Feb 05, 2021  08:28:36 AM"
        purchasedLabel.font = getCustomFont(size: 14, name: .regular)
        self.addSubview(purchasedLabel)
        purchasedLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(orderIdLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: OrderDataSource?) {
        self.descStatusLabel.text = "You will receive the order on \(TimeConverter().getDateFromInt(cellData?.createdAt ?? 0)). Please keep your phone to get calls from the shipper"
        self.orderDetailLabel.text = cellData?.code ?? ""
        self.purchasedLabel.text = TimeConverter().getDateFromInt(cellData?.createdAt ?? 0)
    }
}
