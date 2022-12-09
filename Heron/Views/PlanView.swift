//
//  PlanView.swift
//  Heron
//
//  Created by Lucas on 12/3/22.
//

import UIKit

class PlanView : UIView {
    private let planIcon = UIImageView()
    private let planName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCircleBackgroundColor
        
        planIcon.image = UIImage.init(named: "plan_icon")
        self.addSubview(planIcon)
        planIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(16)
        }
        
        planName.text = " User's plan "
        planName.font = getCustomFont(size: 13, name: .regular)
        planName.textColor = .white
        self.addSubview(planName)
        planName.snp.makeConstraints { make in
            make.centerY.equalTo(planIcon.snp.centerY)
            make.left.equalTo(planIcon.snp.right).offset(2)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
