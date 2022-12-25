//
//  ReviewRate.swift
//  Heron
//
//  Created by Longnn on 24/11/2022.
//

import Foundation
class ReviewRate: UIView {
    let reviewView    = UIView()
    let stack         = UIStackView(frame: .zero)
    private let title = UILabel()
    let stars         = UILabel()
    let reviewCount   = UILabel()
    let showAll       = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.text = "Reviews"
        title.textColor = kDefaultTextColor
        title.font = getCustomFont(size: 13, name: .bold)
        
        let starImage = UIImageView()
        starImage.image = UIImage.init(named: "star_icon")

        stars.text = "4.5"
        stars.textColor = kDefaultTextColor
        stars.font = getCustomFont(size: 13, name: .regular)
        
        reviewCount.text = "80 reviews"
        reviewCount.textColor = kDefaultTextColor
        reviewCount.font = getCustomFont(size: 13, name: .regular)
        
        reviewView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
        }
        
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fill
        
        stack.addSubview(starImage)
        starImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        stack.addSubview(stars)
        stars.snp.makeConstraints { make in
            make.left.equalTo(starImage.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(11)
        }
        
        let spaceLine2 = UIView()
        stack.addSubview(spaceLine2)
        spaceLine2.backgroundColor = kDefaultGreyColor
        spaceLine2.snp.makeConstraints { (make) in
            make.left.equalTo(stars.snp.right).offset(10)
            make.width.equalTo(0.5)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }

        stack.addSubview(reviewCount)
        reviewCount.snp.makeConstraints { make in
            make.left.equalTo(spaceLine2.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        let arrowLeft = UIButton(type: .custom)
        arrowLeft.setImage(UIImage(named: "arrowright"), for: .normal)
        arrowLeft.tintColor = kDefaultTextColor
        stack.addSubview(arrowLeft)
        arrowLeft.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
        }
        
        stack.addSubview(showAll)
        showAll.text = "Show all"
        showAll.textColor  = kDefaultTextColor
        showAll.font = getCustomFont(size: 11, name: .regular)
        showAll.snp.makeConstraints { make in
            make.right.equalTo(arrowLeft.snp.left).offset(-10)
            make.top.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
        }
        
        reviewView.addSubview(stack)
        stack.alignment = .center
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-30)
            make.top.equalTo(title.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
        }
        
        self.addSubview(reviewView)
        reviewView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().offset(0)
            make.width.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
