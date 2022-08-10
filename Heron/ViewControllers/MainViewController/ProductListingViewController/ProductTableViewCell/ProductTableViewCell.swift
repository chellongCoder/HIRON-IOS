//
//  ProductTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit

protocol ProductCellDelegate : AnyObject {
    func addProductToCart(_ data: ProductDataSource)
}

class ProductTableViewCell: UITableViewCell {
    
    let packageImage        = UIImageView()
    let discountValue       = DiscountValueView()
    let productTitleLabel   = UILabel()
    let starView            = UILabel()
    let priceLabel          = DiscountLabel()
    let priceDiscount       = UILabel()
//    let addToCartBtn        = UIButton()
    
    private var productData : ProductDataSource?
    var delegate            : ProductCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }

        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(18)
            make.width.height.equalTo(80)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
        }
        
        contentView.addSubview(discountValue)
        discountValue.snp.makeConstraints { make in
            make.top.equalTo(packageImage.snp.top).offset(5)
            make.centerX.equalTo(packageImage.snp.right).offset(5)
        }
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 0
        productTitleLabel.font = getFontSize(size: 16, weight: .medium)
        productTitleLabel.textColor = kDefaultTextColor
        productTitleLabel.numberOfLines = 0
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(discountValue.snp.right).offset(10)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        starView.text = "★★★★★"
        starView.font = getFontSize(size: 16, weight: .medium)
        starView.textColor = UIColor.init(hexString: "F1C644")
        contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom)
            make.left.right.equalTo(productTitleLabel)
        }
        
        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        priceLabel.text = "$ 20.00"
        priceLabel.setTextColor(kDisableColor)
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
            make.right.lessThanOrEqualTo(productTitleLabel)
        }
        
//        addToCartBtn.setTitle("Add to cart", for: .normal)
//        addToCartBtn.backgroundColor = kPrimaryColor
//        addToCartBtn.layer.cornerRadius = 8
//        addToCartBtn.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
//        contentView.addSubview(addToCartBtn)
//        addToCartBtn.snp.makeConstraints { make in
//            make.top.equalTo(priceDiscount.snp.bottom).offset(10)
//            make.right.equalToSuperview().offset(-20)
//            make.height.equalTo(40)
//            make.left.equalTo(productTitleLabel)
//            make.bottom.lessThanOrEqualToSuperview().offset(-10)
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: ProductDataSource) {
        
        self.productData = cellData
        
        self.productTitleLabel.text = cellData.name
        if let imageURL = URL.init(string: cellData.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        self.priceLabel.text = String(format: "$%.2f", cellData.customRegularPrice)
        self.priceDiscount.text = String(format: "$%.2f", cellData.customFinalPrice)
        self.priceLabel.isHidden = (cellData.customRegularPrice == cellData.customFinalPrice)
        
        if cellData.discountPercent > 0 {
            self.discountValue.isHidden = false
            self.discountValue.contentLabel.text = String(format: "-%.f%%", cellData.discountPercent )
        } else {
            self.discountValue.isHidden = true
        }
    }
    
    @objc private func removeButtonTapped() {
        if let productData = productData {
            delegate?.addProductToCart(productData)
        }
    }
}
