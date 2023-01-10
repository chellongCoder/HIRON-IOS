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
        self.backgroundColor = kPinkColor
        
        contentLabel.text = "-50%"
        contentLabel.textColor = kRedHightLightColor
        contentLabel.font = getCustomFont(size: 11, name: .bold)
        self.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-6)
            make.height.equalToSuperview().offset(-3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
