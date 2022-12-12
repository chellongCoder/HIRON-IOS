//
//  TotalOrderTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit

class OrderTotalInView: UIView {

    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        title.font = getCustomFont(size: 14, name: .regular)
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
