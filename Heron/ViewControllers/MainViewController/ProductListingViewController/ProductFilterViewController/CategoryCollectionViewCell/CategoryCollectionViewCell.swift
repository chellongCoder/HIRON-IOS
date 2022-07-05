//
//  CategoryCollectionViewCell.swift
//  Heron
//
//  Created by Luu Luc on 14/05/2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let cardView = UIView()
    private let titleLabel  = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        cardView.layer.cornerRadius = 8
        cardView.layer.borderColor = kPrimaryColor.cgColor
        cardView.layer.borderWidth = 1
        self.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().offset(-30)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(data : CategoryDataSource) {
        self.titleLabel.text = data.name
    }
    
    func setSelected(_ isSelected : Bool) {
        
        if isSelected {
            cardView.layer.borderWidth = 4
        } else {
            cardView.layer.borderWidth = 1
        }
    }
}
