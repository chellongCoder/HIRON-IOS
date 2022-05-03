//
//  BannerView.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit

class BannerView: UIView {

    private let bannerImage = UIImageView()
//    private var data: BannerDataSource?

    override init(frame: CGRect) {
        super.init(frame: frame)

        bannerImage.image = UIImage.init(named: "Campaign banner 6")
        bannerImage.contentMode = .scaleToFill
        bannerImage.layer.cornerRadius = 8
        bannerImage.clipsToBounds = true
        self.addSubview(bannerImage)
        bannerImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onClickEvent), for: .touchUpInside)
        self.addSubview(button)
        button.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(bannerImage)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onClickEvent() {
        
    }
}

