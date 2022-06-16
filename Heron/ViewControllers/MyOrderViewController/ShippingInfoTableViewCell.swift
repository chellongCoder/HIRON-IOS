//
//  ShippingInfoTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//
import RxSwift

class ShippingInfoTableViewCell: UITableViewCell {
    let statusLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)


            let contentView = UIView()
            contentView.backgroundColor = .white
            self.contentView.addSubview(contentView)
            contentView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(2)
                make.bottom.equalToSuperview()
            }
            
            statusLabel.text = "Address Information"
            contentView.addSubview(statusLabel)
            statusLabel.snp.makeConstraints {
                $0.top.left.equalToSuperview().offset(10)
            }
            
            let descStatusLabel = UILabel()
            descStatusLabel.text = "Shipping Address"
            contentView.addSubview(descStatusLabel)
            descStatusLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(statusLabel.snp.bottom).offset(10)
            }
            
            let orderIdLabel = UILabel()
            orderIdLabel.text = "Lisa Nguyen | 0332578456"
            contentView.addSubview(orderIdLabel)
            orderIdLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(descStatusLabel.snp.bottom).offset(10)
            }

            let purchasedId = UILabel()
            purchasedId.text = "Araseli Sanchez \n2559 haas street \nEscondido, California, 92025 \nUnited States"
            purchasedId.numberOfLines = 0
            contentView.addSubview(purchasedId)
            purchasedId.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(orderIdLabel.snp.bottom).offset(10)
            }
            
            let seperate_line = UIView()
            seperate_line.backgroundColor = .lightGray
            contentView.addSubview(seperate_line)
            seperate_line.snp.makeConstraints {
                $0.height.equalTo(1)
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.top.equalTo(purchasedId.snp.bottom).offset(10)
            }

            let billingAddressLabel = UILabel()
            billingAddressLabel.text = "Billing Address"
            contentView.addSubview(billingAddressLabel)
            billingAddressLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(seperate_line.snp.bottom).offset(10)
            }

            let billingAddressName = UILabel()
            billingAddressName.text = "Lisa Nguyen | 0332578456"
            contentView.addSubview(billingAddressName)
            billingAddressName.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(billingAddressLabel.snp.bottom).offset(10)
            }

            let billingAddressEmail = UILabel()
            billingAddressEmail.text = "lisanguyen@gmail.com"
            contentView.addSubview(billingAddressEmail)
            billingAddressEmail.snp.makeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(billingAddressName.snp.bottom).offset(10)
                $0.bottom.equalToSuperview().offset(-10)
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setDataSource(_ cellData: CartItemDataSource, indexPath: IndexPath) {
        }
    }
