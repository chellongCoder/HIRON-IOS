//
//  FeatureView.swift
//  Heron
//
//  Created by Lucas on 12/25/22.
//

import UIKit

class FeatureView: UIView {
    
    let imageView               = UIImageView()
    let contentView             = UIView()
    private let discountValue   = DiscountValueView()
    private let truePriceLabel  = UILabel()
    private let sourcePriceLabel    = DiscountLabel()
    private let productTitleLabel   = UILabel()
    private let productType         = ChipView.init(title: "Physical Product")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "default-image")
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalToSuperview()
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        contentView.addSubview(discountValue)
        discountValue.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-13)
            make.left.equalToSuperview().offset(12)
        }
        
        truePriceLabel.text = "$10.00"
        truePriceLabel.textColor = kDefaultTextColor
        truePriceLabel.font = getCustomFont(size: 13, name: .extraBold)
        contentView.addSubview(truePriceLabel)
        truePriceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(discountValue.snp.bottom)
            make.left.equalTo(discountValue.snp.right).offset(6)
        }
        
        sourcePriceLabel.text = "$20.00"
        sourcePriceLabel.setTextColor(kDefaultTextColor)
        sourcePriceLabel.font = getCustomFont(size: 11, name: .semiBold)
        contentView.addSubview(sourcePriceLabel)
        sourcePriceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(discountValue.snp.bottom)
            make.left.equalTo(truePriceLabel.snp.right).offset(6)
            make.right.lessThanOrEqualToSuperview().offset(-10)
        }
        
        productTitleLabel.text = ""
        productTitleLabel.font = getCustomFont(size: 13, name: .regular)
        productTitleLabel.textColor = kDefaultTextColor
        productTitleLabel.numberOfLines = 2
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalTo(discountValue.snp.top).offset(-8)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(productType)
        productType.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalTo(productTitleLabel.snp.top).offset(-7)
            make.right.lessThanOrEqualToSuperview().offset(-16)
            make.top.greaterThanOrEqualToSuperview().offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func setDataSource(_ productData: ProductDataSource) {
        if let imageURL = URL.init(string: productData.thumbnailUrl ?? "") {
            self.imageView.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        if productData.discountPercent > 0 {
            self.discountValue.isHidden = false
            self.discountValue.contentLabel.text = String(format: "-%.f%%", productData.discountPercent )
        } else {
            self.discountValue.isHidden = true
        }
        
        self.productTitleLabel.text = productData.name
        self.sourcePriceLabel.text = getMoneyFormat(productData.customRegularPrice)
        self.truePriceLabel.text = getMoneyFormat(productData.customFinalPrice)
        self.sourcePriceLabel.isHidden = (productData.customRegularPrice == productData.customFinalPrice)
        
        switch productData.type {
        case .configurable:
            productType.textLabel.text = "Configurable Product"
        case .simple:
            productType.textLabel.text = "Simple Product"
        }
    }
}
