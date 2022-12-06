//
//  UserDashboardItem.swift
//  Heron
//
//  Created by Lucas on 12/3/22.
//

import UIKit

class UserDashboardItem : UIView {
    private let value = UILabel()
    private let lable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.alpha = 0.35
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
        
        value.text = "0"
        value.textColor = .white
        value.textAlignment = .center
        value.font = getCustomFont(size: 20, name: .bold)
        self.addSubview(value)
        value.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.centerX.equalToSuperview()
        }
        
        lable.text = "Voucher"
        lable.textColor = .white
        lable.textAlignment = .center
        lable.font = getCustomFont(size: 13, name: .regular)
        self.addSubview(lable)
        lable.snp.makeConstraints { make in
            make.top.equalTo(value.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
