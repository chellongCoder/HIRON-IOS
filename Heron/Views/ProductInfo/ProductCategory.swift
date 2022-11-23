//
//  ProductCategory.swift
//  Heron
//
//  Created by Longnn on 13/11/2022.
//

import Foundation
import UIKit

class ProductCategory: UIView {
    
    let textLabel   = UILabel()
    
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = kDefaultGreyColor.cgColor
                
        self.textLabel.text = title
        self.textLabel.textColor = .white
        self.textLabel.font = getCustomFont(size: 13, name: .regular)
        self.textLabel.textColor = UIColor.init(hexString: "808080")!
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
