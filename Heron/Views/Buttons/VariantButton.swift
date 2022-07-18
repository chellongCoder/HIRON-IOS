//
//  VariantButton.swift
//  Heron
//
//  Created by Luu Luc on 18/07/2022.
//

import UIKit

class VariantButton: UIButton {
    
    private var variantValue    : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.setTitle(String(format: "  %@  ", variantValue), for: .normal)
        self.setTitle(String(format: "  %@  ", variantValue), for: .selected)
        self.setTitleColor(kDefaultTextColor, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.setBackgroundImage(UIImage(color: kDisableColor), for: .normal)
        self.setBackgroundImage(UIImage(color: kPrimaryColor), for: .selected)
        self.titleLabel?.font = getFontSize(size: 12, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateVariant(_ newValue: String) {
        self.variantValue = newValue
        self.setTitle(String(format: "  %@  ", variantValue), for: .normal)
        self.setTitle(String(format: "  %@  ", variantValue), for: .selected)
    }
}
