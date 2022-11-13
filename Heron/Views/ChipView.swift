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
