//
//  ProductTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let starView            = UILabel()
    let priceLabel          = UILabel()
    let priceDiscount       = UILabel()
    let addToCartBtn        = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.setShadow()
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
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
            make.width.height.equalTo(120)
        }
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 0
        productTitleLabel.font = getFontSize(size: 16, weight: .medium)
        productTitleLabel.textColor = kSpaceCadetColor
        productTitleLabel.numberOfLines = 0
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
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
        priceDiscount.textColor = kNeonFuchsiaColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = "$ 20.00"
        priceLabel.textColor = kGrayTextColor
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
        }
        
        addToCartBtn.setTitle("Add to cart", for: .normal)
        addToCartBtn.backgroundColor = kCyanTextColor
        addToCartBtn.layer.cornerRadius = 8
        contentView.addSubview(addToCartBtn)
        addToCartBtn.snp.makeConstraints { make in
            make.top.equalTo(priceDiscount.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(130)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - DataSource
    func setDataSource(_ data: ProductDataSource) {
        
    }
}
