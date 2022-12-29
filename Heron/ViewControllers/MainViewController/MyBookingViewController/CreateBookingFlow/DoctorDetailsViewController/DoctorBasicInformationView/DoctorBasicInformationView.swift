//
//  DoctorBasicInformationView.swift
//  Heron
//
//  Created by Lucas on 12/29/22.
//

import UIKit

class DoctorBasicInformationView: UIView {

    let imageIcon   = UIImageView()
    let inforLabel  = UILabel()
    let inforValue  = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageIcon.image = UIImage(named: "default-image")
        imageIcon.contentMode = .scaleAspectFit
        imageIcon.layer.borderColor = kPrimaryColor.cgColor
        imageIcon.backgroundColor = kIceBlueColor
        imageIcon.layer.borderWidth = 0.5
        imageIcon.layer.cornerRadius = 16
        self.addSubview(imageIcon)
        imageIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.height.width.equalTo(32)
        }
        
        inforLabel.text = "Place of Employment"
        inforLabel.font = getCustomFont(size: 11.5, name: .regular)
        inforLabel.textColor = kCustomTextColor
        inforLabel.textAlignment = .left
        self.addSubview(inforLabel)
        inforLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(imageIcon.snp.right).offset(12)
        }
        
        inforValue.text = "Brooklyn Hospital Brooklyn Hospital Brooklyn Hospital Brooklyn Hospital Brooklyn Hospital Brooklyn Hospital"
        inforValue.font = getCustomFont(size: 13.5, name: .regular)
        inforValue.textColor = kDefaultTextColor
        inforValue.textAlignment = .left
        inforValue.numberOfLines = 0
        self.addSubview(inforValue)
        inforValue.snp.makeConstraints { make in
            make.top.equalTo(inforLabel.snp.bottom).offset(6)
            make.left.equalTo(inforLabel)
            make.right.equalToSuperview().offset(-50)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
