//
//  PackageTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//

import RxSwift
import UIKit

class PackageTableViewCell: UITableViewCell {
    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let priceLabel          = DiscountLabel()
    let priceDiscount       = UILabel()
    let countLabel          = UILabel()
    let tagContentLabel     = ChipView(title: "")
    
    private var orderItem   : OrderItems?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        
        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(50)
            make.height.equalTo(61)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        priceDiscount.text = "$0.00"
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.textAlignment = .right
        priceDiscount.font = getCustomFont(size: 13, name: .semiBold)
        priceDiscount.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceDiscount.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 2
        productTitleLabel.font = getCustomFont(size: 11, name: .regular)
        productTitleLabel.textColor = kCustomTextColor
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.right.equalTo(priceDiscount.snp.left).offset(-5)
            make.top.equalTo(packageImage)
        }
        
        tagContentLabel.textLabel.font = getCustomFont(size: 11, name: .regular)
        tagContentLabel.textLabel.textColor = kCustomTextColor
        contentView.addSubview(tagContentLabel)
        tagContentLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(4)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = "$0.00"
        priceLabel.textColor = kDefaultTextColor
        priceLabel.font = .systemFont(ofSize: 11, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(priceDiscount.snp.bottom).offset(2)
            make.right.equalTo(priceDiscount)
        }
        
        countLabel.text = "x0"
        countLabel.textColor = kCustomTextColor
        countLabel.font = getCustomFont(size: 11, name: .regular)
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(priceLabel.snp.bottom).offset(6)
            make.centerY.equalTo(tagContentLabel)
            make.right.equalTo(priceDiscount)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: OrderItems) {
        
        self.productTitleLabel.text = cellData.name
        if let imageURL = URL.init(string: cellData.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        self.priceLabel.text = getMoneyFormat(cellData.customRegularPrice)
        self.priceDiscount.text = getMoneyFormat(cellData.customFinalPrice)
        
        var contentText = ""
        
        for (_, attribute) in cellData.metadata?.attributes ?? [:] {
            if let label = attribute.label {
                contentText = String(format: "%@, %@ %@", contentText, label, attribute.value ?? "")
            }
        }
        
        if !contentText.isEmpty {
            contentText.removeFirst()
        }
        
        self.tagContentLabel.textLabel.text = contentText
        
        self.countLabel.text = String(format: "x%ld", cellData.quantity)
    }
}
