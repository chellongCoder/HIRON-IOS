//
//  StackInfoProductView.swift
//  Heron
//
//  Created by Longnn on 12/11/2022.
//

import UIKit

class StackInfoView: UIView {

    let stack           = ScrollableStackView()
    let discountView    = DiscountView()
    let originalPrice   = DiscountLabel()
    let salePrice       = UILabel()
    let saleAmount      = UILabel()
    let spaceLine       = UIView()
    let starView        = UILabel()
    let pointView       = UILabel()
    let reviewView      = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
    
        stack.distribution  = .fillProportionally
        stack.alignment = .center
        stack.spacing = 4
        
        discountView.backgroundColor = UIColor.init(hexString: "ffe2e2")
        discountView.layer.cornerRadius = 3
        stack.addSubview(discountView)
        discountView.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        originalPrice.text = "$150.00"
        originalPrice.font = getCustomFont(size: 11, name: .medium)
        originalPrice.setTextColor(kDefaultTextColor)
        stack.addSubview(originalPrice)
        originalPrice.snp.makeConstraints { (make) in
            make.left.equalTo(discountView.snp.right).offset(4)
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        salePrice.text = "$100.00"
        salePrice.font = getCustomFont(size: 16, name: .bold)
        salePrice.textColor = kDefaultTextColor
        stack.addSubview(salePrice)
        salePrice.snp.makeConstraints { (make) in
            make.left.equalTo(originalPrice.snp.right).offset(4)
            make.centerY.equalToSuperview()
        }

        reviewView.text = "80 reviews"
        reviewView.underline()
        reviewView.font = getCustomFont(size: 11, name: .regular)
        reviewView.textColor = kDefaultTextColor
        stack.addSubview(reviewView)
        reviewView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        let spaceLine2 = UIView()
        stack.addSubview(spaceLine2)
        spaceLine2.backgroundColor = kDefaultGreyColor
        spaceLine2.snp.makeConstraints { (make) in
            make.right.equalTo(reviewView.snp.left).offset(-4)
            make.centerY.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(14)
        }
        
        starView.text = "★"
        starView.font = getCustomFont(size: 11, name: .regular)
        starView.textColor = UIColor.init(hexString: "ff6d6e")
        stack.addSubview(starView)
        starView.snp.makeConstraints { (make) in
            make.right.equalTo(spaceLine2.snp.left).offset(-4)
            make.centerY.equalToSuperview()
        }
        
        spaceLine.backgroundColor = kDefaultGreyColor
        stack.addSubview(spaceLine)
        spaceLine.snp.makeConstraints { (make) in
            make.right.equalTo(starView.snp.left).offset(-4)
            make.centerY.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(14)
        }
        
        saleAmount.text = "120 sales"
        saleAmount.font = getCustomFont(size: 11, name: .regular)
        saleAmount.textColor = kDefaultTextColor
        stack.addSubview(saleAmount)
        saleAmount.snp.makeConstraints { (make) in
            make.right.equalTo(spaceLine.snp.left).offset(-2)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }
    
    func setDiscountPercent(_ str: String) {
        self.discountView.setDiscount(str)
    }
    
    func setOriginalPrice(_ str: String) {
        self.originalPrice.text = str
    }
    
    func setSalePrice(_ str: String) {
        self.salePrice.text = str
    }
    
    func setSaleAmount(_ str: String) {
        if(str != "1") {
            self.saleAmount.text = "\(str) sales"
        } else {
            self.saleAmount.text = "\(str) sale"
        }
    }
    
    func setStars(_ str: String) {
        self.starView.text = str
    }

    func setPointView(_ str: String) {
        self.pointView.text = str
    }
    
    func setReviewView(_ str: String) {
        self.reviewView.text = "\(str) reviews"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
