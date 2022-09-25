//
//  EmptyView.swift
//  Heron
//
//  Created by Luu Luc on 21/09/2022.
//

import UIKit

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
        titleLabel.font = getFontSize(size: 20, weight: .bold)
        titleLabel.textColor = kDefaultTextColor
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        
        messageLabel.text = "All incoming requests will be listed in this folder"
        messageLabel.textColor = kDefaultTextColor
        messageLabel.font = getFontSize(size: 20, weight: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
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
