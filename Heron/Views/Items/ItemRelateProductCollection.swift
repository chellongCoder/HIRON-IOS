//
//  ItemRelateProductCollection.swift
//  Heron
//
//  Created by Longnn on 04/12/2022.
//

import Foundation

class ItemRelateProductCollection: UICollectionViewCell {
    let banner          = UIImageView()
    let productName     = UILabel()
    let discount        = DiscountView()
    let originalPrice   = DiscountLabel()
    let salePrice       = UILabel()
    let star            = UILabel()
    let starPoint       = UILabel()
    let heartItem       = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        banner.image = UIImage.init(named: "banner_image4")
        banner.backgroundColor = .red
        banner.contentMode = .scaleAspectFill
        banner.layer.cornerRadius = 15
        banner.layer.masksToBounds = true
        self.contentView.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.width.height.equalTo(165)
            make.centerX.equalToSuperview()
            make.top.left.equalToSuperview()
        }
        
        productName.text = "DNA Scientific Wellness"
        productName.font = getCustomFont(size: 13, name: .regular)
        productName.textColor = kDefaultTextColor
        self.contentView.addSubview(productName)
        productName.snp.makeConstraints { make in
            make.top.equalTo(banner.snp.bottom)
            make.left.equalToSuperview()
        }
        
        heartItem.setImage(UIImage(systemName: "heart"), for: .normal)
        heartItem.tintColor = kDefaultTextColor
        self.contentView.addSubview(heartItem)
        heartItem.snp.makeConstraints { make in
            make.top.equalTo(banner.snp.bottom)
            make.right.equalToSuperview()
        }

        
        discount.setDiscount("30%")
        discount.backgroundColor = UIColor.init(hexString: "ffe2e2")
        discount.layer.cornerRadius = 3
        self.contentView.addSubview(discount)
        discount.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.top.equalTo(productName.snp.bottom).offset(10)
            make.left.equalToSuperview()
        }

        originalPrice.text = "$150.00"
        originalPrice.font = getCustomFont(size: 9, name: .regular)
        self.contentView.addSubview(originalPrice)
        originalPrice.snp.makeConstraints { make in
            make.top.equalTo(productName.snp.bottom).offset(20)
            make.left.equalTo(discount.snp.right).offset(10)
        }
        
        salePrice.text = "$150.00"
        salePrice.font = getCustomFont(size: 13, name: .bold)
        self.contentView.addSubview(salePrice)
        salePrice.snp.makeConstraints { make in
            make.top.equalTo(discount.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        starPoint.text = "4.5"
        starPoint.font = getCustomFont(size: 11, name: .regular)
        self.contentView.addSubview(starPoint)
        starPoint.snp.makeConstraints { make in
            make.top.equalTo(discount.snp.bottom).offset(10)
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        star.text = "★"
        star.font = getCustomFont(size: 11, name: .bold)
        star.textColor = UIColor.init(hexString: "ff6d6e")
        self.contentView.addSubview(star)
        star.snp.makeConstraints { make in
            make.top.equalTo(discount.snp.bottom).offset(10)
            make.right.equalTo(starPoint.snp.left)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
