//
//  VW_DiscountValue.swift
//  Heron
//
//  Created by Luu Luc on 21/06/2022.
//

import UIKit

class DiscountValueView: UIView {
    
    public let contentLabel     = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.backgroundColor = kRedHightLightColor
        
        contentLabel.text = "-50%"
        contentLabel.textColor = .white
        contentLabel.font = getFontSize(size: 11, weight: .heavy)
        self.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.equalToSuperview().offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
