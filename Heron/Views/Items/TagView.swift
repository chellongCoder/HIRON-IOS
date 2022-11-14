//
//  TagView.swift
//  Heron
//
//  Created by Longnn on 11/11/2022.
//

import UIKit

class TagView: UIView {
    
    let textLabel   = UILabel()
    
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
                
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
