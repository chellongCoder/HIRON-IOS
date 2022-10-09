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
        self.backgroundColor = UIColor(hexString: "E4E7EB")?.withAlphaComponent(0.4)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = kDefaultTextColor.cgColor
                
        self.textLabel.text = title
        self.textLabel.textColor = .white
        self.textLabel.font = getFontSize(size: 12, weight: .medium)
        self.textLabel.textColor = kDefaultTextColor
        self.textLabel.textAlignment = .center
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
