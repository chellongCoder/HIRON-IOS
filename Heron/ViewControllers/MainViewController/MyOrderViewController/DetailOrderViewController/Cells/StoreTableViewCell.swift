//
//  StoreTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 11/10/2022.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    let storeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        storeLabel.font = getCustomFont(size: 13, name: .bold)
        storeLabel.textColor = kDefaultTextColor
        storeLabel.text = ""
        self.addSubview(storeLabel)
        storeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStoreDataSource(_ store: StoreDataSource?) {
        self.storeLabel.text = store?.name ?? ""
    }
}
