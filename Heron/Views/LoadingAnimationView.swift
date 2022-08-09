//
//  VW_LoadingAnimation.swift
//  Heron
//
//  Created by Luu Lucas on 9/21/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingAnimationView: UIView {

    var loadingAnimation        = NVActivityIndicatorView(frame: .zero,
                                                          type: .ballScaleMultiple,
                                                          color: kPrimaryColor)

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = kCyanTextColor

        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.alpha = 0.5
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }

        loadingAnimation.startAnimating()
        self.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.5)
        }

        let logoImage = UIImageView(image: UIImage(named: "AppIcon_HighDimension"))
        logoImage.layer.cornerRadius = 40
        logoImage.layer.masksToBounds = true
        self.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
