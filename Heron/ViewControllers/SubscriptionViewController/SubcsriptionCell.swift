//
//  SubcsriptionCell.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit

class SubcriptionCollectionViewCell: UICollectionViewCell {
    
    private let cardView = UIView()
    let titleLabel      = UILabel()
    let priceLabel      = UILabel()
    let intervalLabel   = UILabel()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        cardView.layer.cornerRadius = 8
        cardView.backgroundColor = kPrimaryColor
        self.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().offset(-30)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.font = getCustomFont(size: 14, name: .medium)
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        
        priceLabel.textAlignment = .center
        priceLabel.numberOfLines = 1
        priceLabel.textColor = .white
        priceLabel.font = getCustomFont(size: 24, name: .bold)
        cardView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        intervalLabel.textAlignment = .center
        intervalLabel.textColor = .white
        intervalLabel.font = getCustomFont(size: 12, name: .bold)
        cardView.addSubview(intervalLabel)
        intervalLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
//        let footerLabel = UILabel()
//        footerLabel.text = "Include 14 days Free"
//        footerLabel.textAlignment = .center
//        footerLabel.numberOfLines = 0
//        footerLabel.textColor = .white
//        footerLabel.font = getCustomFont(size: 12, weight: .medium)
//        cardView.addSubview(footerLabel)
//        footerLabel.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().offset(-10)
//            make.centerX.equalToSuperview()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(data : SubscriptionData) {
        self.titleLabel.text = data.subsItem?.name
        self.priceLabel.text = getMoneyFormat(data.customFinalPrice)
        if data.interval_count == 1 {
            self.intervalLabel.text = String(format: "/%@", data.interval.rawValue)
        } else {
            self.intervalLabel.text = String(format: "/%ld %@s", data.interval_count, data.interval.rawValue)
        }
        
//         self.footerLabel.text = String(format: "From: %@", getMoneyFormat(data.customRegularPrice))
    }
    
    func setSelected(_ isSelected : Bool) {
        if isSelected {
            cardView.layer.borderWidth = 4
        } else {
            cardView.layer.borderWidth = 0
        }
    }
}
