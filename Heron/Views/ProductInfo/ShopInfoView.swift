//
//  ShopInfoView.swift
//  Heron
//
//  Created by Longnn on 16/11/2022.
//

import Foundation
class ShopProductView: UIView {
    let avatar      = UIImageView()
    let shopName    = UILabel()
    let shopDesc    = UILabel()
    let btnViewShop = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        
        #warning("Hard code")
        self.addSubview(avatar)
        avatar.image = UIImage.init(named: "store")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = 25
        avatar.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        let view = UIView()
        view.addSubview(shopName)
        shopName.text = "Pharmacity"
        shopName.font = getCustomFont(size: 13, name: .regular)
        shopName.textColor = kDefaultTextColor
        shopName.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        view.addSubview(shopDesc)
        shopDesc.text = "Lorem Ipsum is simply dummy text of the printing and typesetting"
        shopDesc.font = getCustomFont(size: 13, name: .regular)
        shopDesc.textColor = UIColor.init(hexString: "888888")
        shopDesc.numberOfLines = 2
        shopDesc.snp.makeConstraints { (make) in
            make.bottom.left.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
        }
        
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(avatar.snp.right).offset(10)
            make.width.equalToSuperview().offset(-100)
            make.height.equalTo(50)
        }
        
        self.addSubview(btnViewShop)
        btnViewShop.layer.borderWidth = 0.5
        btnViewShop.layer.cornerRadius = 5
        btnViewShop.layer.borderColor = kDefaultGreenColor.cgColor
        btnViewShop.setTitle("View shop", for: .normal)
        btnViewShop.setTitleColor(kDefaultGreenColor, for: .normal)
        btnViewShop.titleLabel?.font = getCustomFont(size: 10, name: .regular)
        btnViewShop.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(65)
            make.height.equalTo(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
