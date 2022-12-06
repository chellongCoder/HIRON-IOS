//
//  UserProfileActionView.swift
//  Heron
//
//  Created by Lucas on 12/3/22.
//

import UIKit

class UserProfileActionBtn : UIButton {
    let actionIcon              = UIImageView()
    let actionName              = UILabel()
    private let narrowImange    = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        actionIcon.image = UIImage.init(named: "user_profile_icon")
        actionIcon.contentMode = .scaleAspectFit
        self.addSubview(actionIcon)
        actionIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(28)
            make.height.width.equalTo(30)
        }
        
        narrowImange.image = UIImage.init(named: "left_icon")
        self.addSubview(narrowImange)
        narrowImange.snp.makeConstraints { make in
            make.top.equalTo(actionIcon)
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        actionName.text = "Update user profile"
        actionName.textColor = kDefaultTextColor
        actionName.font = getCustomFont(size: 13, name: .regular)
        self.addSubview(actionName)
        actionName.snp.makeConstraints { make in
            make.top.equalTo(actionIcon)
            make.left.equalTo(actionIcon.snp.right).offset(12)
            make.right.equalTo(narrowImange.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
