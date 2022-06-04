//
//  CartHotView.swift
//  Heron
//
//  Created by Luu Luc on 01/06/2022.
//

import UIKit

class CartHotView: UIView {
    
    let cartPriceValue  = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear//kPrimaryColor
        self.layer.cornerRadius = 25
                
        let cartIcon = UIImageView(image: UIImage.init(systemName: "cart")?.withRenderingMode(.alwaysTemplate))
        cartIcon.tintColor = .white
        self.addSubview(cartIcon)
        cartIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
            make.left.equalToSuperview().offset(15)
        }
        
        cartPriceValue.textColor = .white
        cartPriceValue.text = "$27.32"
        self.addSubview(cartPriceValue)
        cartPriceValue.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalTo(cartIcon.snp.right).offset(10)
        }
        
        let rightIcon = UIImageView(image: UIImage(systemName: "chevron.right"))
        rightIcon.tintColor = .white
        self.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(15)
            make.left.equalTo(cartPriceValue.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
