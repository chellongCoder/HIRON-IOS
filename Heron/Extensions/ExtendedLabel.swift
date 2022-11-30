//
//  ExtendedLabel.swift
//  Heron
//
//  Created by Lucas on 11/30/22.
//

import Foundation
import UIKit

class LeftRightImageLabel: UIView {
    var leftImageView   : UIImageView?
    var textLabel       : UILabel?
    var rightImageView  : UIImageView?
    
    init(leftImage: UIImage? = nil, rightImage: UIImage? = nil) {
        
        super.init(frame: .zero)
        
        textLabel = UILabel()
        self.addSubview(textLabel!)
        textLabel!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(2)
            make.right.lessThanOrEqualToSuperview().offset(-2)
        }

        if let leftImage = leftImage {
            self.leftImageView = UIImageView()
            leftImageView?.image = leftImage
            leftImageView?.contentMode = .scaleAspectFit
            self.addSubview(leftImageView!)
            leftImageView!.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(2)
                make.height.width.equalTo(self.snp.height)
                make.right.lessThanOrEqualTo(textLabel!.snp.left).offset(-2)
            }
        }
        
        if let rightImage = rightImage {
            self.rightImageView = UIImageView()
            rightImageView?.image = rightImage
            rightImageView?.contentMode = .scaleAspectFit
            self.addSubview(rightImageView!)
            rightImageView!.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-2)
                make.height.width.equalTo(self.snp.height)
                make.left.greaterThanOrEqualTo(self.textLabel!.snp.right).offset(2)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
