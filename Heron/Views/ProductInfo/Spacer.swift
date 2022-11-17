//
//  Spacer.swift
//  Heron
//
//  Created by Longnn on 15/11/2022.
//

import Foundation
class SpacerView: UIView {
    
    let view = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true

        self.addSubview(view)
        view.backgroundColor = kDefaultDarkGreyColor
        view.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(0)
            make.height.equalToSuperview().offset(0)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
