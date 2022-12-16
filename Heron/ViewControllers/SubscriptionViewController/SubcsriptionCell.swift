//
//  SubcsriptionCell.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit

// swiftlint:disable class_delegate_protocol
protocol SubcriptionCellDelegate {
    func didSelectPlan(_ plan: SubscriptionData)
}

class SubcriptionCell: UIView {
    
    private let cardView = UIImageView()
    let titleLabel      = UILabel()
    let priceLabel      = UILabel()
    let intervalLabel   = UILabel()
    let iconImage       = UIImageView()
   
    private var subscriptionPlan: SubscriptionData?
    var delegate        : SubcriptionCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        let selectAction = UITapGestureRecognizer.init(target: self, action: #selector(didTapSubscriptionPlan))
        self.addGestureRecognizer(selectAction)
        
        cardView.layer.cornerRadius = 8
        cardView.layer.borderWidth = 0
        cardView.layer.borderColor = kPrimaryColor.cgColor
        cardView.backgroundColor = .white
        cardView.layer.shadowColor = kPrimaryColor.cgColor // Màu đổ bóng
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5) // Hướng đổ bóng + right/bottom, - left/top
        cardView.layer.shadowRadius = 5 // Độ rộng đổ bóng
        cardView.layer.shadowOpacity = 0.2 // Độ đậm nhạt
        cardView.layer.cornerRadius = 8
        self.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().offset(-20)
        }
        
        iconImage.image = UIImage.init(named: "group2_icon")
        cardView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.height.width.equalTo(40)
        }
        
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.textColor = kDefaultTextColor
        titleLabel.font = getCustomFont(size: 18, name: .semiBold)
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(10)
            make.left.equalTo(iconImage)
            make.centerX.equalToSuperview()
        }
        
        priceLabel.textAlignment = .left
        priceLabel.numberOfLines = 1
        priceLabel.textColor = kDefaultTextColor
        priceLabel.font = getCustomFont(size: 25, name: .extraBold)
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)
        cardView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(titleLabel)
        }
        
        intervalLabel.textAlignment = .left
        intervalLabel.textColor = kDefaultTextColor
        intervalLabel.font = getCustomFont(size: 11, name: .medium)
        cardView.addSubview(intervalLabel)
        intervalLabel.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel.snp.bottom)
            make.height.equalTo(26)
            make.left.equalTo(priceLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        let footerLabel = UILabel()
        footerLabel.text = "Include 14 days free"
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        footerLabel.textColor = kPrimaryColor
        footerLabel.backgroundColor = kIceBlueColor
        footerLabel.layer.cornerRadius = 6
        footerLabel.layer.masksToBounds = true
        footerLabel.font = getCustomFont(size: 11, name: .medium)
        cardView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-34)
            make.height.equalTo(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(data : SubscriptionData, currentSelectedPlan: SubscriptionData? = nil) {
        
        self.subscriptionPlan = data
        
        self.titleLabel.text = data.subsItem?.name
        self.priceLabel.text = getMoneyFormat(data.customFinalPrice)
        if data.interval_count == 1 {
            self.intervalLabel.text = String(format: "/%@", data.interval.rawValue)
        } else {
            self.intervalLabel.text = String(format: "/%ld %@s", data.interval_count, data.interval.rawValue)
        }
        
        if data == currentSelectedPlan {
            cardView.layer.borderWidth = 2
        } else {
            cardView.layer.borderWidth = 0
        }
    }
    
    @objc private func didTapSubscriptionPlan() {
        if let subscriptionPlan = subscriptionPlan {
            self.delegate?.didSelectPlan(subscriptionPlan)
        }
    }
}
