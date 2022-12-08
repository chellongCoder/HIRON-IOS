//
//  SelectDateCollectionViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 28/07/2022.
//

import UIKit

class SelectDateCalendarFlowLayout: UICollectionViewFlowLayout {

    let cellSpacing: CGFloat = 4

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 4.0
        self.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 6)
        let attributes = super.layoutAttributesForElements(in: rect)
        self.itemSize = CGSize(width: 170, height: 45)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

class SelectDateCollectionViewCell: UICollectionViewCell {

    var layoutView              = UIView()
    var selectOption            = UILabel()
    var cornerRadius: CGFloat   = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutView.layer.cornerRadius = cornerRadius
        layoutView.backgroundColor = .white
        layoutView.layer.borderWidth = 1
        layoutView.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(layoutView)
        layoutView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }

        selectOption.textAlignment = .center
        selectOption.font = getCustomFont(size: 14, name: .semiBold)
        selectOption.textColor = .gray
        layoutView.addSubview(selectOption)
        selectOption.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
