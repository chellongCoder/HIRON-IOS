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
        self.layer.borderWidth = 0.5

        self.setTitleColor(UIColor.init(hexString: "808080"), for: .selected)
        self.titleLabel?.font = getCustomFont(size: 12, name: .medium)
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
            self.layer.borderColor = kDefaultGreyColor.cgColor
            self.backgroundColor = .white
            self.setTitleColor(kDefaultTextColor, for: .normal)
        case .normmal:
            self.isUserInteractionEnabled = true
            self.layer.borderColor = kDefaultGreyColor.cgColor
            self.backgroundColor = .white
            self.setTitleColor(kDefaultTextColor, for: .normal)
        case .selected:
            self.isUserInteractionEnabled = true
            self.layer.borderColor = UIColor(hexString: "14c1c2")?.cgColor
            self.backgroundColor = UIColor(hexString: "eefbfb")
            self.setTitleColor(UIColor(hexString: "14c1c2"), for: .normal)
        case .disable:
            self.isUserInteractionEnabled = false
            self.backgroundColor = UIColor.init(hexString: "F0F0F0")
        }
    }
}
