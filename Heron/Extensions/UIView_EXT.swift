//
//  UIView_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

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

    func zoomIn(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = .identity
            }) { (_: Bool) -> Void in
        }
    }

    func zoomOut(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (_: Bool) -> Void in
        }
    }

    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
            }, completion: { (completed: Bool) -> Void in
                UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                    self.transform = .identity
                    }, completion: { (_: Bool) -> Void in
                })
        })
    }
}
