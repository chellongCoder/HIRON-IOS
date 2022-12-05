//
//  CheckoutItemTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 12/06/2022.
//

import UIKit
import RxRelay

class CheckoutItemTableViewCell: UITableViewCell {
    
    let packageImage        = UIImageView()
    let tagsContent         = UILabel()
    let productTitleLabel   = UILabel()
    let priceLabel          = DiscountLabel()
    let priceDiscount       = UILabel()
    
    let countLabel          = UILabel()
    private var itemData    : CartItemDataSource?
    private var indexPath   : IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        
        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        self.contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(50)
            make.height.equalTo(60)
            make.bottom.lessThanOrEqualToSuperview().offset(-11)
        }
        
        productTitleLabel.text = ""
        productTitleLabel.numberOfLines = 2
        productTitleLabel.font = getCustomFont(size: 11, name: .regular)
        productTitleLabel.textColor = kCustomTextColor
        self.contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        tagsContent.text = ""
        tagsContent.numberOfLines = 0
        tagsContent.font = getCustomFont(size: 10, name: .regular)
        tagsContent.textColor = kDefaultTextColor
        self.contentView.addSubview(tagsContent)
        tagsContent.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.top.equalTo(productTitleLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-16)
        }
        
        countLabel.text = "x1"
        countLabel.font = getCustomFont(size: 13, name: .regular)
        countLabel.textColor = kDefaultTextColor
        countLabel.textAlignment = .left
        self.contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.bottom.equalTo(packageImage)
        }

        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kDefaultTextColor
        priceDiscount.font = getCustomFont(size: 13, name: .regular)
        self.contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.left.equalTo(countLabel.snp.right).offset(30)
            make.bottom.equalTo(packageImage)
            make.bottom.lessThanOrEqualToSuperview().offset(-11)
        }
        
//        priceLabel.text = "$ 20.00"
//        priceLabel.setTextColor(kDisableColor)
//        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
//        self.contentView.addSubview(priceLabel)
//        priceLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(tagsContent.snp.bottom).offset(10)
//            make.left.equalTo(priceDiscount.snp.right).offset(5)
//            make.bottom.lessThanOrEqualToSuperview().offset(-10)
//        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DataSources
    func setDataSource(itemData: CartItemDataSource, index: IndexPath) {
        self.itemData = itemData
        self.indexPath = index
        
        self.productTitleLabel.text = itemData.product?.name
        if let imageURL = URL.init(string: itemData.product?.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        self.priceLabel.text = getMoneyFormat(itemData.product!.customRegularPrice)
        self.priceDiscount.text = getMoneyFormat(itemData.product!.customFinalPrice)
        self.priceLabel.isHidden = (itemData.product!.customRegularPrice == itemData.product!.customFinalPrice)
        self.countLabel.text = String(format: "x%ld", itemData.quantity)
        
        guard let productData = itemData.product else {return}
        var contentText = ""
        switch productData.featureType {
        case .ecom:
            contentText = "Physical Product"
        case .ecom_booking:
            contentText = "Virtual Product"
        }
        
        if let unitName = productData.unit?.name {
            contentText = String(format: "%@, %@", contentText, unitName)
        }
        
        if let brandName = productData.brand?.name {
            contentText = String(format: "%@, %@", contentText, brandName)
        }
        
        for (_, attribute) in productData.attributes {
            if let label = attribute.label {
                contentText = String(format: "%@, %@ %@", contentText, label, attribute.value ?? "")
            }
        }
        
        self.tagsContent.text = contentText
    }
}
