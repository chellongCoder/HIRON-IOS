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
    private let imageView   = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        cardView.layer.cornerRadius = 8
        cardView.layer.borderColor = UIColor.white.cgColor
        cardView.layer.borderWidth = 0.5
        self.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(125)
            make.width.equalTo(85)
        }
        
        imageView.image = UIImage.init(named: "")
        imageView.contentMode = .scaleAspectFit
        cardView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.font = getCustomFont(size: 11, name: .medium)
        titleLabel.numberOfLines = 0
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-14)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
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
    
    func setCategoryUICode(_ code: CategoryUIData) {
        self.cardView.backgroundColor = UIColor.init(hexString: code.backgroundColorCode)
        self.imageView.image = UIImage.init(named: code.imageName)?.withRenderingMode(.alwaysTemplate)
        self.imageView.tintColor = UIColor.init(hexString: code.textColorCode)!
        self.titleLabel.textColor = UIColor.init(hexString: code.textColorCode)
    }
}
