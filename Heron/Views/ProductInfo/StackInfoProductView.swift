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
    let originnalPrice  = UILabel()
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
        
        /// TODO: UI discount view
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
        
        /// TODO: UI original view
        originnalPrice.text = "$150.00"
        originnalPrice.strikeThrough(true)
        originnalPrice.font = getFontSize(size: 11, weight: .medium)
        originnalPrice.textColor = kDefaultBlackColor
        stack.addSubview(originnalPrice)
        originnalPrice.snp.makeConstraints { (make) in
            make.left.equalTo(discountView.snp.right).offset(10)
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        /// TODO: UI sale price view
        salePrice.text = "$100.00"
        salePrice.font = getFontSize(size: 16, weight: .bold)
        salePrice.textColor = kDefaultBlackColor
        stack.addSubview(salePrice)
        salePrice.snp.makeConstraints { (make) in
            make.left.equalTo(originnalPrice.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
//
       
        
        
        /// TODO: UI sale amount view
        reviewView.text = "80 reviews"
        reviewView.underline()
        reviewView.font = getFontSize(size: 11, weight: .regular)
        reviewView.textColor = kDefaultBlackColor
        stack.addSubview(reviewView)
        reviewView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        let spaceLine2 = UIView()
        stack.addSubview(spaceLine2)
        spaceLine2.backgroundColor = kDefaultGreyColor
        spaceLine2.snp.makeConstraints { (make) in
            make.right.equalTo(reviewView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(14)
        }
        
        /// TODO: UI star view
        starView.text = "★"
        starView.font = getFontSize(size: 11, weight: .regular)
        starView.textColor = UIColor.init(hexString: "ff6d6e")
        stack.addSubview(starView)
        starView.snp.makeConstraints { (make) in
            make.right.equalTo(spaceLine2.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        /// TODO: UI point view
        starView.text = "★"
        starView.font = getFontSize(size: 11, weight: .regular)
        starView.textColor = UIColor.init(hexString: "ff6d6e")
        stack.addSubview(starView)
        starView.snp.makeConstraints { (make) in
            make.right.equalTo(spaceLine2.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        spaceLine.backgroundColor = kDefaultGreyColor
        stack.addSubview(spaceLine)
        spaceLine.snp.makeConstraints { (make) in
            make.right.equalTo(starView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(14)
        }
        
        /// TODO: UI sale amount view
        saleAmount.text = "120 sales"
        saleAmount.font = getFontSize(size: 11, weight: .regular)
        saleAmount.textColor = kDefaultBlackColor
        stack.addSubview(saleAmount)
        saleAmount.snp.makeConstraints { (make) in
            make.right.equalTo(spaceLine.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
