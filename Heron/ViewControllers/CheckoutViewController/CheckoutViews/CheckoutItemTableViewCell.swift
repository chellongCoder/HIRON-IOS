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
    let priceLabel          = UILabel()
    let priceDiscount       = UILabel()
    
    let countLabel          = UILabel()
    private var itemData    : CartItemDataSource?
    private var indexPath   : IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(120)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        productTitleLabel.text = ""
        productTitleLabel.numberOfLines = 0
        productTitleLabel.font = getFontSize(size: 16, weight: .medium)
        productTitleLabel.textColor = kDefaultTextColor
        productTitleLabel.numberOfLines = 0
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        tagsContent.text = ""
        tagsContent.numberOfLines = 0
        tagsContent.font = getFontSize(size: 12, weight: .regular)
        tagsContent.textColor = kDefaultTextColor
        contentView.addSubview(tagsContent)
        tagsContent.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(productTitleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-16)
        }

        
        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(tagsContent.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = "$ 20.00"
        priceLabel.textColor = kDisableColor
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagsContent.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
        }
        
        countLabel.text = "x1"
        countLabel.font = getFontSize(size: 16, weight: .medium)
        countLabel.textColor = kDefaultTextColor
        countLabel.textAlignment = .right
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(packageImage).offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
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
        
        self.priceLabel.text = String(format: "$%.2f", itemData.product!.customRegularPrice)
        self.priceDiscount.text = String(format: "$%.2f", itemData.product!.customFinalPrice)
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
        
        self.tagsContent.text = contentText
    }
}
