//
//  PaymentTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    let statusLabel         = UILabel()
    let descStatusLabel     = UILabel()
    
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
        
        statusLabel.text = "Payment method"
        statusLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        descStatusLabel.text = "Paid without cards"
        contentView.addSubview(descStatusLabel)
        descStatusLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(statusLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
