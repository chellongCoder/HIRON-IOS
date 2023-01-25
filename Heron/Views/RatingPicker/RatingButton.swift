//
//  RatingButton.swift
//  Heron
//
//  Created by Longnn on 25/01/2023.
//

import Foundation
class RatingButton : UIButton {
    init(_ title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = kPrimaryColor.cgColor
        self.layer.cornerRadius = 18.5
        self.backgroundColor = kIceBlueColor
        self.titleLabel?.font = getCustomFont(size: 13.5, name: .bold)
        self.setTitleColor(kDefaultTextColor, for: .normal)
        let star = UIImageView(frame: .zero)
        star.image = UIImage.init(named: "star_rating")
        star.contentMode = .scaleAspectFit
        self.addSubview(star)
        star.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
            make.right.equalTo(-17)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderWidth = 1
                self.layer.borderColor = kPrimaryColor.cgColor
                self.layer.cornerRadius = 18.5
                self.backgroundColor = kPrimaryColor
                self.titleLabel?.font = getCustomFont(size: 13.5, name: .bold)
                self.setTitleColor(UIColor.init(hexString: "ffffff"), for: .normal)
            } else {
                self.layer.borderWidth = 1
                self.layer.borderColor = kPrimaryColor.cgColor
                self.layer.cornerRadius = 18.5
                self.backgroundColor = kIceBlueColor
                self.titleLabel?.font = getCustomFont(size: 13.5, name: .bold)
                self.setTitleColor(kDefaultTextColor, for: .normal)
                
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
