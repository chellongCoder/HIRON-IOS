//
//  OrderTotalView.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

class OrderTotalView: UIView {
    
    private let title       = UILabel()
    let subtotalLabel       = UILabel()
    let subTotalValue       = UILabel()
    let discountLabel       = UILabel()
    let discountValue       = UILabel()
    let shippingAndTaxLabel = UILabel()
    let shippingAndTaxValue = UILabel()
    
    let totalLabel          = UILabel()
    let totalValue          = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.setShadow()
        
        let markIcon = UIImageView.init(image: UIImage(systemName: "cart"))
        markIcon.tintColor = kPrimaryColor
        self.addSubview(markIcon)
        markIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.height.width.equalTo(20)
        }
        
        title.text = "Order Total"
        title.textColor = kDefaultTextColor
        title.font = .systemFont(ofSize: 16)
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalTo(markIcon)
            make.left.equalTo(markIcon.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hexString: "F6F6F6")!
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }
        
        subtotalLabel.text = "Subtotal:"
        subtotalLabel.textAlignment = .left
        subtotalLabel.font = .systemFont(ofSize: 14)
        self.addSubview(subtotalLabel)
        subtotalLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        subTotalValue.text = "$0"
        subTotalValue.textAlignment = .right
        subTotalValue.font = .systemFont(ofSize: 14)
        self.addSubview(subTotalValue)
        subTotalValue.snp.makeConstraints { make in
            make.centerY.equalTo(subtotalLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        discountLabel.text = "Voucher's discount:"
        discountLabel.textAlignment = .left
        discountLabel.font = .systemFont(ofSize: 14)
        self.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { make in
            make.top.equalTo(subTotalValue.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        discountValue.text = "$0"
        discountValue.textAlignment = .right
        discountValue.font = .systemFont(ofSize: 14)
        self.addSubview(discountValue)
        discountValue.snp.makeConstraints { make in
            make.centerY.equalTo(discountLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        shippingAndTaxLabel.text = "Shipping and Tax:"
        shippingAndTaxLabel.textAlignment = .left
        shippingAndTaxLabel.font = .systemFont(ofSize: 14)
        self.addSubview(shippingAndTaxLabel)
        shippingAndTaxLabel.snp.makeConstraints { make in
            make.top.equalTo(discountValue.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        shippingAndTaxValue.text = "$0"
        shippingAndTaxValue.textAlignment = .right
        shippingAndTaxValue.font = .systemFont(ofSize: 14)
        self.addSubview(shippingAndTaxValue)
        shippingAndTaxValue.snp.makeConstraints { make in
            make.centerY.equalTo(shippingAndTaxLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        totalLabel.text = "Total:"
        totalLabel.textAlignment = .left
        totalLabel.font = .boldSystemFont(ofSize: 16)
        self.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingAndTaxValue.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        totalValue.text = "$0"
        totalValue.textAlignment = .right
        totalValue.font = .boldSystemFont(ofSize: 16)
        self.addSubview(totalValue)
        totalValue.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
