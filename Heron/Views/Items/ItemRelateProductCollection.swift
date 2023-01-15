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
    let discount        = DiscountValueView()
    let originalPrice   = DiscountLabel()
    let salePrice       = UILabel()
    let star            = UILabel()
    let starPoint       = UILabel()
    let heartItem       = ExtendedButton()
    
    @objc private func likeTapped(button: ExtendedButton) {
        button.setSeleted(!button.isSelected)
    }
    
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
            make.top.equalTo(banner.snp.bottom).offset(8)
            make.left.equalToSuperview()
        }
        
        heartItem.setBackgroundImage(UIImage.init(named: "heartActive"), for: .selected)
        heartItem.setBackgroundImage(UIImage.init(named: "heart"), for: .normal)
        heartItem.addTarget(self, action: #selector(likeTapped(button:)), for: .touchUpInside)
        heartItem.tintColor = kDefaultTextColor
        self.contentView.addSubview(heartItem)
        heartItem.snp.makeConstraints { make in
            make.top.equalTo(banner.snp.bottom).offset(5)
            make.right.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        self.discount.contentLabel.text = "-30%"
        self.discount.contentLabel.font = getCustomFont(size: 7, name: .bold)
        self.discount.layer.cornerRadius = 2
        self.contentView.addSubview(discount)
        self.discount.contentLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-4)
            make.height.equalToSuperview().offset(-3)
        }
        self.discount.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(10)
            make.top.equalTo(productName.snp.bottom).offset(6)
            make.left.equalToSuperview()
        }

        originalPrice.text = "$150.00"
        originalPrice.font = getCustomFont(size: 11, name: .regular)
        self.contentView.addSubview(originalPrice)
        originalPrice.snp.makeConstraints { make in
            make.top.equalTo(productName.snp.bottom).offset(6)
            make.left.equalTo(discount.snp.right).offset(4)
        }
        
        salePrice.text = "$150.00"
        salePrice.font = getCustomFont(size: 13, name: .bold)
        self.contentView.addSubview(salePrice)
        salePrice.snp.makeConstraints { make in
            make.top.equalTo(discount.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(0)
        }
        
        starPoint.text = "4.5"
        starPoint.font = getCustomFont(size: 11, name: .regular)
        self.contentView.addSubview(starPoint)
        starPoint.snp.makeConstraints { make in
            make.top.equalTo(discount.snp.bottom).offset(10)
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(0)
        }

        star.text = "★"
        star.font = getCustomFont(size: 11, name: .bold)
        star.textColor = kRedPinkColor
        self.contentView.addSubview(star)
        star.snp.makeConstraints { make in
            make.top.equalTo(discount.snp.bottom).offset(10)
            make.right.equalTo(starPoint.snp.left)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
