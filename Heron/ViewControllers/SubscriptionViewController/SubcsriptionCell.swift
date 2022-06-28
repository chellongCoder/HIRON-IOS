//
//  SubcsriptionCell.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit

class SubcriptionCollectionViewCell: UICollectionViewCell {
    
    private let cardView = UIView()
    let titleLabel  = UILabel()
    let priceLabel  = UILabel()
    let footerLabel = UILabel()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
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
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        
        priceLabel.textAlignment = .center
        priceLabel.numberOfLines = 0
        cardView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        cardView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(data : CategoryDataSource) {
        self.titleLabel.text = data.name;
    }
    
    func setSelected(_ isSelected : Bool) {
        if isSelected {
            cardView.layer.borderWidth = 4
        } else {
            cardView.layer.borderWidth = 1
        }
    }
}