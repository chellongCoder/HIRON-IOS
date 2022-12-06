//
//  TutorialCell.swift
//  Heron
//
//  Created by Lucas on 12/6/22.
//

import UIKit

class TutorialCell: UIView {
    
    private let whiteView       = UIView()
    private let contentLabel    = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        whiteView.layer.cornerRadius = 17
        whiteView.backgroundColor = .white
        self.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.top.height.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
        }
        
        contentLabel.text = ""
        contentLabel.textAlignment = .center
        contentLabel.text = "Access your patient history, lab results, future appointments and more."
        contentLabel.font = getCustomFont(size: 18, name: .regular)
        contentLabel.textColor = kLoginTextColor
        contentLabel.layer.cornerRadius = 17
        contentLabel.numberOfLines = 0
        whiteView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
