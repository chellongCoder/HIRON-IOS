//
//  Footer.swift
//  Heron
//
//  Created by Longnn on 16/11/2022.
//

import Foundation
class ProductDetailFooter: UIView {
    private let cardAction      = UIView()
    private let btnBuyNow       = UIButton()
    private let btnAddtoCard    = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let remove = UIButton()
        remove.setTitle("-", for: .normal)
        remove.setTitleColor(kDefaultTextColor, for: .normal)
        remove.titleLabel?.font = getCustomFont(size: 13, name: .regular)
        let count = UILabel()
        count.text = "1"
        count.textColor = kDefaultTextColor
        count.font = getCustomFont(size: 13, name: .regular)
        let add = UIButton()
        add.setTitle("+", for: .normal)
        add.setTitleColor(kDefaultTextColor, for: .normal)
        add.titleLabel?.font = getCustomFont(size: 13, name: .regular)
        
        cardAction.addSubview(add)
        cardAction.addSubview(count)
        cardAction.addSubview(remove)
        add.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        let lineView1 = UIView()
        lineView1.backgroundColor = kDefaultGreyColor
        add.addSubview(lineView1)
        lineView1.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(add.snp.right).offset(0)
            make.height.equalTo(30)
            make.width.equalTo(1)
        }
        
        count.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        remove.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        let lineView2 = UIView()
        lineView2.backgroundColor = kDefaultGreyColor
        remove.addSubview(lineView2)
        lineView2.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(remove.snp.left).offset(0)
            make.height.equalTo(30)
            make.width.equalTo(1)
        }
        
        self.addSubview(cardAction)
        cardAction.layer.borderWidth = 0.7
        cardAction.layer.cornerRadius = 6
        cardAction.layer.borderColor = kDefaultGreyColor.cgColor
        cardAction.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(106)
            make.height.equalTo(30)
        }
        
        self.addSubview(btnAddtoCard)
        btnAddtoCard.layer.cornerRadius = 20
        btnAddtoCard.titleLabel?.font = getCustomFont(size: 14, name: .regular)
        btnAddtoCard.setTitle("Add to cart", for: .normal)
        btnBuyNow.setTitleColor(.white, for: .normal)
        btnAddtoCard.backgroundColor = kDefaultGreenColor
        btnAddtoCard.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(106)
            make.height.equalTo(40)
        }
        
        self.addSubview(btnBuyNow)
        btnBuyNow.layer.borderWidth = 0.7
        btnBuyNow.layer.cornerRadius = 20
        btnBuyNow.titleLabel?.font = getCustomFont(size: 14, name: .regular)
        btnBuyNow.setTitle("Buy now", for: .normal)
        btnBuyNow.setTitleColor(kDefaultGreenColor, for: .normal)
        btnBuyNow.backgroundColor = UIColor.init(hexString: "eefbfb")
        btnBuyNow.layer.borderColor = kDefaultGreenColor.cgColor
        btnBuyNow.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(btnAddtoCard.snp.left).offset(-10)
            make.width.equalTo(106)
            make.height.equalTo(40)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
