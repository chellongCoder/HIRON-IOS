//
//  GroupCategory.swift
//  Heron
//
//  Created by Longnn on 13/11/2022.
//

import Foundation
import UIKit

class GroupProductCategory: UIView {
    private let textLabel       = UILabel()
    private let tagsViewStack   = UIStackView()

    init(title: String, categories: [String]) {
        super.init(frame: .zero)
        
        self.textLabel.text = title
        self.textLabel.textColor = kDefaultBlackColor
        self.textLabel.font = getFontSize(size: 11, weight: .regular)
        self.textLabel.textColor = kDefaultTextColor

        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        tagsViewStack.axis  = .horizontal
        tagsViewStack.distribution  = .fillProportionally
        tagsViewStack.alignment = .center
        tagsViewStack.spacing = 10
        self.addSubview(tagsViewStack)
        for item in categories {
            let newCategory = ProductCategory.init(title: item.trimmed)
            newCategory.snp.makeConstraints { make in
                make.height.equalTo(28)
            }
            tagsViewStack.addArrangedSubview(newCategory)
        }

        tagsViewStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
