//
//  ActionButton.swift
//  Heron
//
//  Created by Luu Luc on 17/07/2022.
//

import UIKit

class ChipViewButton: UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.setTitle("  Test daiff  ", for: .normal)
        self.setTitleColor(kDefaultTextColor, for: .normal)
        self.titleLabel?.font = getFontSize(size: 12, weight: .medium)
        self.backgroundColor = kDisableColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
