//
//  BrandView.swift
//  Heron
//
//  Created by Lucas on 12/22/22.
//

import UIKit

class BrandView: UIView {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = kLightGrayColor.cgColor
        self.layer.borderWidth = 0.5
        
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalToSuperview().offset(-15)
        }
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
