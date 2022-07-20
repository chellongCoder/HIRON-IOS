//
//  VariantButton.swift
//  Heron
//
//  Created by Luu Luc on 18/07/2022.
//

import UIKit

enum VariantButtonState {
    case showOnly
    case normmal
    case selected
    case disable
}

class VariantButton: UIButton {
    
    var variantValue    : SelectedVariant?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
                
        self.setTitleColor(.white, for: .selected)
        self.titleLabel?.font = getFontSize(size: 12, weight: .medium)
        self.setTitle(String(format: "  %@  ", variantValue?.value ?? ""), for: .normal)
        self.setTitleColor(kDefaultTextColor, for: .normal)
        
        self.setState(.showOnly)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateVariant(_ newValue: SelectedVariant) {
        self.variantValue = newValue
        self.setTitle(String(format: "  %@  ", variantValue?.value ?? ""), for: .normal)
    }
    
    func setState(_ state: VariantButtonState) {
        switch state {
        case .showOnly:
            self.isUserInteractionEnabled = false
            self.layer.borderColor = kDefaultTextColor.cgColor
            self.backgroundColor = .white
            self.setTitleColor(kDefaultTextColor, for: .normal)
        case .normmal:
            self.isUserInteractionEnabled = true
            self.layer.borderColor = kDefaultTextColor.cgColor
            self.backgroundColor = .white
            self.setTitleColor(kDefaultTextColor, for: .normal)
        case .selected:
            self.isUserInteractionEnabled = true
            self.layer.borderColor = kPrimaryColor.cgColor
            self.backgroundColor = .white
            self.setTitleColor(kPrimaryColor, for: .normal)
        case .disable:
            self.isUserInteractionEnabled = false
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.backgroundColor = .lightGray
            self.setTitleColor(kDisableColor, for: .normal)
        }
    }
}
