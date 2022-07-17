//
//  ConfigurationProductVariantView.swift
//  Heron
//
//  Created by Luu Luc on 17/07/2022.
//

import UIKit

protocol ProductVariantDelegate {
    func didSelectVariant(id: [String])
}

class ConfigurationProductVariantView: UIView {
    
    var configurations  : [ConfigurableOption] = []
    var allConfigView   = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.addSubview(allConfigView)
        allConfigView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI() {
        for view in allConfigView.subviews {
            view.removeFromSuperview()
        }
        
        var lastConfig : UIView?
        for configuration in configurations {
            if configuration.values.count > 0 {
                let configurationTitle = UILabel()
                configurationTitle.text = configuration.label
                configurationTitle.textColor = kDefaultTextColor
                configurationTitle.font = getFontSize(size: 16, weight: .medium)
                allConfigView.addSubview(configurationTitle)
                
                if lastConfig != nil {
                    configurationTitle.snp.makeConstraints { make in
                        make.top.equalTo(lastConfig!.snp.bottom).offset(20)
                        make.left.equalToSuperview().offset(17)
                        make.bottom.lessThanOrEqualToSuperview().offset(-10)
                    }
                } else {
                    configurationTitle.snp.makeConstraints { make in
                        make.top.equalToSuperview().offset(20)
                        make.left.equalToSuperview().offset(17)
                        make.bottom.lessThanOrEqualToSuperview().offset(-10)
                    }
                }
                
                let countLabel = UILabel()
                countLabel.text = String(format: "(%ld types)", configuration.values.count)
                countLabel.textColor = kDefaultTextColor
                countLabel.font = getFontSize(size: 14, weight: .regular)
                allConfigView.addSubview(countLabel)
                countLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(configurationTitle)
                    make.left.equalTo(configurationTitle.snp.right).offset(5)
                }
                
                if configuration.values.count > 0 {
                    let scrollView = UIScrollView()
                    allConfigView.addSubview(scrollView)
                    scrollView.snp.makeConstraints { make in
                        make.top.equalTo(configurationTitle.snp.bottom).offset(5)
                        make.left.right.equalToSuperview()
                        make.bottom.equalTo(configurationTitle.snp.bottom).offset(55)
                        make.bottom.lessThanOrEqualToSuperview().offset(-10)
                    }
                    
                    lastConfig = scrollView
                    
                    var lastBtn : UIButton?
                    for value in configuration.values {
                        let chipButton = UIButton()
                        chipButton.addTarget(self, action: #selector(didSelectTheValue(_:)), for: .touchUpInside)
                        chipButton.layer.cornerRadius = 10
                        chipButton.setTitle(String(format: "  %@  ", value), for: .normal)
                        chipButton.setTitleColor(kDefaultTextColor, for: .normal)
                        chipButton.titleLabel?.font = getFontSize(size: 12, weight: .medium)
                        chipButton.backgroundColor = kDisableColor
                        scrollView.addSubview(chipButton)

                        if lastBtn != nil {
                            chipButton.snp.makeConstraints { make in
                                make.left.equalTo(lastBtn!.snp.right).offset(14)
                                make.top.equalToSuperview().offset(10)
                                make.centerY.equalToSuperview()
                                make.height.equalTo(24)
                            }
                        } else {
                            chipButton.snp.makeConstraints { make in
                                make.left.equalToSuperview().offset(14)
                                make.top.equalToSuperview().offset(10)
                                make.centerY.equalToSuperview()
                                make.height.equalTo(50)
                            }
                        }

                        lastBtn = chipButton
                    }
                    
                    if let lastBtn = lastBtn {
                        lastBtn.snp.makeConstraints { make in
                            make.right.lessThanOrEqualToSuperview().offset(-14)
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didSelectTheValue(_ sender: UIButton) {
        
    }
}
