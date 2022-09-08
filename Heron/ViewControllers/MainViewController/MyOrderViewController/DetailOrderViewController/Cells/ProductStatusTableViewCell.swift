//
//  ProductStatusTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//

import RxSwift
import UIKit

extension UILabel {
    
}

class ProductStatusTableViewCell: UITableViewCell {
    let statusLabel = UILabel()
    let descStatusLabel = UILabel()
    let orderDetailLabel = UILabel()
    let purchasedLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 0.094, green: 0.565, blue: 1, alpha: 0.05)
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        statusLabel.text = "Prepare product to you"
        statusLabel.textColor = kPrimaryColor
        statusLabel.font = getFontSize(size: 18, weight: .bold)
        statusLabel.font = .boldSystemFont(ofSize: 18)
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        descStatusLabel.text = "You will receive the order in Feb 05, 2021. Please keep your phone to get calling from deliver"
        descStatusLabel.font = getFontSize(size: 14, weight: .regular)
        descStatusLabel.textColor = kDefaultTextColor
        descStatusLabel.numberOfLines = 0
        contentView.addSubview(descStatusLabel)
        descStatusLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(statusLabel.snp.bottom).offset(10)
        }
        
        let orderIdLabel = UILabel()
        orderIdLabel.text = "Order ID"
        orderIdLabel.font = getFontSize(size: 14, weight: .medium)
        contentView.addSubview(orderIdLabel)
        orderIdLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(descStatusLabel.snp.bottom).offset(10)
        }
        
        let purchasedId = UILabel()
        purchasedId.text = "Purchased date"
        purchasedId.font = getFontSize(size: 14, weight: .medium)
        contentView.addSubview(purchasedId)
        purchasedId.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(orderIdLabel.snp.bottom).offset(10)
        }
        
        orderDetailLabel.text = "ORD1234567891CD"
        orderDetailLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(orderDetailLabel)
        orderDetailLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(descStatusLabel.snp.bottom).offset(10)
        }
        
        purchasedLabel.text = "Feb 05, 2021  08:28:36 AM"
        purchasedLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(purchasedLabel)
        purchasedLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(orderIdLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: CartItemDataSource, indexPath: IndexPath) {
    }
}
