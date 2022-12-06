//
//  ExtendedButton.swift
//  Heron
//
//  Created by Lucas on 11/30/22.
//

import UIKit

/// Extend custom button
class ExtendedButton : UIButton {
    let contentImage = UIImageView()
    private var seletedImage : UIImage?
    private var normalImage : UIImage?
    
    init() {
        super.init(frame: .zero)
        
        contentImage.contentMode = .scaleAspectFit
        self.addSubview(contentImage)
        contentImage.snp.makeConstraints { make in
            make.height.width.equalToSuperview().multipliedBy(0.5)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        
        if state == .selected {
            self.seletedImage = image
        } else if state == .normal {
            self.normalImage = image
            self.contentImage.image = image
        }
    }
    
    func setSeleted(_ isSelect: Bool) {
        self.isSelected = isSelect
        if isSelect {
            self.contentImage.image = seletedImage
        } else {
            self.contentImage.image = normalImage
        }
    }
}
