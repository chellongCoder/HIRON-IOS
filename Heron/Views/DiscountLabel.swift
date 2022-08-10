//
//  DiscountLabel.swift
//  Heron
//
//  Created by Luu Luc on 10/08/2022.
//

import UIKit

class DiscountLabel: UILabel {
    private let discountLine    = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        discountLine.backgroundColor = self.textColor
        self.addSubview(discountLine)
        discountLine.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().offset(-4)
        }
    }
    
    func setTextColor(_ color: UIColor) {
        self.textColor = color
        self.discountLine.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
