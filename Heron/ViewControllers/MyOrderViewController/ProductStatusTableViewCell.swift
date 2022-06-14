//
//  ProductStatusTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//

import RxSwift
import UIKit

class ProductStatusTableViewCell: UITableViewCell {
    let statusLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)

            let contentView = UIView()
//            contentView.setShadow()
            self.contentView.addSubview(contentView)
            contentView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
            }
            
            statusLabel.text = "Prepare product to you"
            contentView.addSubview(statusLabel)
            statusLabel.snp.makeConstraints {
                $0.top.left.equalToSuperview().offset(10)
            }
            
            let descStatusLabel = UILabel()
            descStatusLabel.text = "You will receive the order in Feb 05, 2021. Please keep your phone to get calling from deliver"
            contentView.addSubview(descStatusLabel)
            descStatusLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(statusLabel.snp.bottom).offset(10)
            }
            
            let orderIdLabel = UILabel()
            orderIdLabel.text = "Order ID"
            contentView.addSubview(orderIdLabel)
            orderIdLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(descStatusLabel.snp.bottom).offset(10)
            }

            let purchasedId = UILabel()
            purchasedId.text = "Purchased date"
            contentView.addSubview(purchasedId)
            purchasedId.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(orderIdLabel.snp.bottom).offset(10)
            }
            
            let orderDetailLabel = UILabel()
            orderDetailLabel.text = "ORD1234567891CD"
            contentView.addSubview(orderDetailLabel)
            orderDetailLabel.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-10)
                $0.top.equalTo(descStatusLabel.snp.bottom).offset(10)
            }

            let purchasedLabel = UILabel()
            purchasedLabel.text = "Feb 05, 2021  08:28:36 AM"
            contentView.addSubview(purchasedLabel)
            purchasedLabel.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-10)
                $0.top.equalTo(orderIdLabel.snp.bottom).offset(10)
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setDataSource(_ cellData: CartItemDataSource, indexPath: IndexPath) {
        }
    }

