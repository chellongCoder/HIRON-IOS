//
//  ProductBannerView.swift
//  Heron
//
//  Created by Longnn on 15/11/2022.
//

import Foundation
class ProductBannerView: UIView {

    let bannerImage     = UIImageView()
//    private var data: BannerDataSource?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        
        bannerImage.image = UIImage.init(named: "default-image")
        bannerImage.contentMode = .scaleAspectFill
        bannerImage.layer.borderColor = UIColor.lightGray.cgColor
        bannerImage.layer.masksToBounds = true
        self.addSubview(bannerImage)
        bannerImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(0)
            make.height.equalToSuperview().offset(0)
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
