//
//  EmptyView.swift
//  Heron
//
//  Created by Luu Luc on 21/09/2022.
//

import UIKit

// swiftlint:disable:next class_delegate_protocol
protocol EmptyViewDelegate {
    func didSelectEmptyButton()
}

class EmptyView: UIView {
    
    let imageView       = UIImageView()
    let titleLabel      = UILabel()
    let messageLabel    = UILabel()
    let actionButon     = UIButton()
    
    var delegate        : EmptyViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage.init(named: "emptyBox")
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
            make.width.equalTo(250)
            make.height.equalTo(200)
        }
        
        titleLabel.text = "Your box is empty"
        titleLabel.font = getCustomFont(size: 16, name: .bold)
        titleLabel.textColor = kDefaultTextColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        
        messageLabel.text = "All incoming requests will be listed in this folder"
        messageLabel.textColor = kDefaultTextColor
        messageLabel.font = getCustomFont(size: 12, name: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.width.equalTo(titleLabel)
        }
        
        actionButon.backgroundColor = kPrimaryColor
        actionButon.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        actionButon.setTitle("OK", for: .normal)
        actionButon.layer.cornerRadius = 8
        self.addSubview(actionButon)
        actionButon.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func okButtonTapped() {
        delegate?.didSelectEmptyButton()
    }
}
