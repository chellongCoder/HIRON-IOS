//
//  TrackingTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 16/06/2022.
//

import UIKit

class TrackingTableViewCell: UITableViewCell {
    private let shippingCarrierLabel     = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)

        let contentView = UIView()
        self.contentView.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview()
        }
        
        let shippingInfoTitle = UILabel()
        shippingInfoTitle.text = "Shipping & Handling Information"
        shippingInfoTitle.font = getCustomFont(size: 16, name: .medium)
        contentView.addSubview(shippingInfoTitle)
        shippingInfoTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        shippingCarrierLabel.font = getCustomFont(size: 14, name: .regular)
        shippingCarrierLabel.text = "Express"
        contentView.addSubview(shippingCarrierLabel)
        shippingCarrierLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(shippingInfoTitle.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: OrderShippingData?) {
        self.shippingCarrierLabel.text = String(format: "Express - %@", cellData?.trackingNumber ?? "Unknow")
    }
}
