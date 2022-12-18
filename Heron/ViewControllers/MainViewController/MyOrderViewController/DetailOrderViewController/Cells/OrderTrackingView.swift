//
//  TrackingTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 16/06/2022.
//

import UIKit

class OrderTrackingView: UIView {
    private let shippingCarrierLabel     = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)

        let contentView = UIView()
        self.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let timeLeftImage = UIImageView()
        timeLeftImage.image = UIImage.init(named: "time_left_icon")
        timeLeftImage.contentMode = .scaleAspectFill
        self.addSubview(timeLeftImage)
        timeLeftImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(20)
        }
        
        let shippingInfoTitle = UILabel()
        shippingInfoTitle.text = "Estimated delivery time"
        shippingInfoTitle.font = getCustomFont(size: 13, name: .bold)
        shippingInfoTitle.textColor = kTitleTextColor
        self.addSubview(shippingInfoTitle)
        shippingInfoTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(timeLeftImage.snp.right).offset(12)
        }
        
        shippingCarrierLabel.font = getCustomFont(size: 13, name: .regular)
        shippingCarrierLabel.text = "Feb 05, 2022 - Feb 07,2022"
        shippingCarrierLabel.textColor = kTitleTextColor
        self.addSubview(shippingCarrierLabel)
        shippingCarrierLabel.snp.makeConstraints {
            $0.left.equalTo(shippingInfoTitle)
            $0.top.equalTo(shippingInfoTitle.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: OrderDataSource?) {
        self.shippingCarrierLabel.text = String(format: "Express - %@", TimeConverter().getDateFromInt(cellData?.createdAt ?? 0))
    }
}
