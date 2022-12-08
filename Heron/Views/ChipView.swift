//
//  ChipView.swift
//  Heron
//
//  Created by Lucas Luu on 20/07/2022.
//

import UIKit

class ChipView: UIView {
    
    let textLabel   = UILabel()
    
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(hexString: "f6f6f6")
        
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
                
        self.textLabel.text = title
        self.textLabel.textColor = kDefaultTextColor
        self.textLabel.font = getCustomFont(size: 9, name: .regular)
        self.textLabel.textColor = kDefaultTextColor
        self.textLabel.textAlignment = .center
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-8)
            make.height.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChipViewDropDown: UIView {
    
    let textLabel   = UILabel()
    let imageIcon   = UIImageView()
    
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(hexString: "f6f6f6")
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
                
        self.textLabel.text = title
        self.textLabel.textColor = kDefaultTextColor
        self.textLabel.font = getCustomFont(size: 11, name: .semiBold)
        self.textLabel.textColor = kDefaultTextColor
        self.textLabel.textAlignment = .center
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.height.equalToSuperview().offset(-9)
        }
        
        self.imageIcon.image = UIImage.init(named: "down_icon")
        self.addSubview(imageIcon)
        imageIcon.snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.left.equalTo(self.textLabel.snp.right).offset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChipViewVoucher: UIView {
    
    let imageIcon   = UIImageView()
    let textLabel   = UILabel()
    let clearBtn    = UIButton()
    
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(hexString: "e7f8f8")
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
                
        self.imageIcon.image = UIImage.init(named: "voucher_icon")
        self.imageIcon.contentMode = .scaleAspectFit
        self.addSubview(imageIcon)
        imageIcon.snp.makeConstraints { make in
            make.height.width.equalTo(14)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
        }
        
        self.textLabel.text = title
        self.textLabel.textColor = kPrimaryColor
        self.textLabel.font = getCustomFont(size: 10, name: .bold)
        self.textLabel.textAlignment = .center
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageIcon.snp.right).offset(8)
            make.height.equalToSuperview().offset(-10)
        }
        
        self.clearBtn.setBackgroundImage(UIImage.init(named: "clear_voucher_btn"), for: .normal)
        self.addSubview(clearBtn)
        clearBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(16)
            make.height.equalToSuperview().offset(-4)
            make.left.equalTo(textLabel.snp.right).offset(12)
            make.right.equalToSuperview().offset(-2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
