//
//  UIView_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        // layerMinXMinYCorner: Top Left, layerMaxXMinYCorner: top right, MinMax: bottom left
    }

    func setShadow() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor // Màu đổ bóng
        self.layer.shadowOffset = CGSize(width: 1, height: 1) // Hướng đổ bóng + right/bottom, - left/top
        self.layer.shadowRadius = 3 // Độ rộng đổ bóng
        self.layer.shadowOpacity = 0.1 // Độ đậm nhạt
        self.layer.cornerRadius = 8
    }
    
    func setDashlineBorder(_ color: UIColor, cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = color.cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(roundedRect: self.bounds,
                                           byRoundingCorners: .allCorners,
                                           cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
}
