//
//  BannerView.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit

class BannerView: UIView {

    let bannerImage     = UIImageView()
//    private var data: BannerDataSource?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        
        bannerImage.image = UIImage.init(named: "default-image")
        bannerImage.contentMode = .scaleAspectFit
        bannerImage.layer.cornerRadius = 8
        bannerImage.layer.borderWidth = 0.5
        bannerImage.layer.borderColor = UIColor.lightGray.cgColor
        bannerImage.layer.masksToBounds = true
        self.addSubview(bannerImage)
        bannerImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(bannerImage.snp.width).multipliedBy(1.2)
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
