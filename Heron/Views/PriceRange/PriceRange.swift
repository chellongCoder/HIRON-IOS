//
//  PriceRange.swift
//  Heron
//
//  Created by Longnn on 23/01/2023.
//

import Foundation

class PriceRange: UIView {
    var ranges = [
        25, 50, 75, 100, 200
    ]
    let btnGo     = UIButton()
    var minTF     = TextField()
    var maxTF     = TextField()
    
    init() {
        super.init(frame: .zero)
        let label = UILabel()
        label.text = "Price Range"
        label.font = getCustomFont(size: 14.5, name: .bold)
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
        }
        var lastView                        : UILabel?

        for (index, range) in ranges.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = String(range)
            titleLabel.font = getCustomFont(size: 13.5, name: .light)
            self.addSubview(titleLabel)
            if lastView != nil {
                titleLabel.snp.makeConstraints { make in
                    make.top.equalTo(lastView!.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(16)
                }
                if(index == ranges.count - 1) {
                    titleLabel.text = "\(range)$ to Above"
                } else {
                    titleLabel.text = "\(range)$ to \(ranges[index+1])"
                }
            } else {
                titleLabel.snp.makeConstraints { make in
                    make.top.equalTo(label.snp.bottom).offset(12)
                    make.left.equalToSuperview().offset(16)
                }
                titleLabel.text = "Under \(range)$"
            }
            
            lastView = titleLabel
        }
        lastView?.snp.makeConstraints({ make in
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        })

        self.addSubview(minTF)
        minTF.layer.borderWidth = 1
        minTF.layer.borderColor = kDefaultGreyColor.cgColor
        minTF.layer.cornerRadius = 6
        minTF.snp.makeConstraints { make in
            make.top.equalTo(lastView!.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        
        self.addSubview(maxTF)
        maxTF.layer.borderWidth = 1
        maxTF.layer.borderColor = kDefaultGreyColor.cgColor
        maxTF.layer.cornerRadius = 6
        maxTF.snp.makeConstraints { make in
            make.top.equalTo(lastView!.snp.bottom).offset(12)
            make.left.equalTo(minTF.snp.right).offset(8)
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }

        self.addSubview(btnGo)
        btnGo.layer.borderWidth = 0.7
        btnGo.layer.cornerRadius = 20
        btnGo.titleLabel?.font = getCustomFont(size: 14, name: .regular)
        btnGo.setTitle("Go", for: .normal)
        btnGo.setTitleColor(kDefaultGreenColor, for: .normal)
        btnGo.backgroundColor = UIColor.init(hexString: "eefbfb")
        btnGo.layer.borderColor = kDefaultGreenColor.cgColor
        btnGo.snp.makeConstraints { (make) in
            make.top.equalTo(lastView!.snp.bottom).offset(12)
            make.left.equalTo(maxTF.snp.right).offset(8)
            make.width.equalTo(59)
            make.height.equalTo(40)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
