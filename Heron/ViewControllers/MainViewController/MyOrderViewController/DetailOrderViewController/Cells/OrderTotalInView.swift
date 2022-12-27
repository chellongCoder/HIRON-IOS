//
//  TotalOrderTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit

class OrderTotalInView: UIView {

    let totalLabel          = UILabel()
    let priceLabel          = UILabel()
    let paymentDetailBtn    = UIButton()
    let imagePaymentBtn     = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let contentView = UIView()
        contentView.backgroundColor = .white
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        totalLabel.font = getCustomFont(size: 13, name: .regular)
        self.addSubview(totalLabel)
        totalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.left.equalToSuperview().offset(16)
        }
        
        priceLabel.font = getCustomFont(size: 13, name: .bold)
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.left.equalTo(totalLabel.snp.right).offset(6)
            $0.right.lessThanOrEqualToSuperview().offset(-10)
        }
        
        imagePaymentBtn.setImage(UIImage.init(named: "down_icon"), for: .normal)
        imagePaymentBtn.contentMode = .scaleAspectFill
        self.addSubview(imagePaymentBtn)
        imagePaymentBtn.snp.makeConstraints { make in
            make.top.equalTo(totalLabel)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(10)
            make.centerY.equalToSuperview()
        }
    
        paymentDetailBtn.setTitle("Payment detail", for: .normal)
        paymentDetailBtn.titleLabel?.font = getCustomFont(size: 11, name: .regular)
        paymentDetailBtn.setTitleColor(kDefaultTextColor, for: .normal)
        self.addSubview(paymentDetailBtn)
        paymentDetailBtn.snp.makeConstraints { make in
            make.top.equalTo(imagePaymentBtn)
            make.right.equalTo(imagePaymentBtn.snp.left).offset(-5)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
