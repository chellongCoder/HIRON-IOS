//
//  TotalOrderTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit

class TotalOrderTableViewCell: UITableViewCell {

    let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        title.font = getFontSize(size: 14, weight: .regular)
        self.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
