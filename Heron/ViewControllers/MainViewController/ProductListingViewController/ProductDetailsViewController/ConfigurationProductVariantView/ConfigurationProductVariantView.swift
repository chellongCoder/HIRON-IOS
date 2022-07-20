//
//  ConfigurationProductVariantView.swift
//  Heron
//
//  Created by Luu Luc on 17/07/2022.
//

import UIKit

protocol ProductVariantDelegate {
    func didSelectVariant(variants: [SelectedVariant])
}

struct SelectedVariant {
    var attributeCode   : String
    var value           : String
}

class ConfigurationProductVariantView: UIView {
    
    private var isAllowToChanged        : Bool = false
    private var configurationProduct    : ProductDataSource?
    private var configurations  : [ConfigurableOption] = []
    private var selectedConfig  : [SelectedVariant] = []
    private var allConfigView   = UIView()
    private var listAllChipButtons : [VariantButton] = []
    
    var delegate    : ProductVariantDelegate?
    
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
    
    func setConfigurationProduct(_ product : ProductDataSource, isAllowToChange: Bool) {
        self.configurationProduct = product
        self.configurations = product.configurableOptions
        self.isAllowToChanged = isAllowToChange
        
        self.selectedConfig.removeAll()
        
        if self.isAllowToChanged {
            for config in configurations {
                let newSelectedVariant = SelectedVariant(attributeCode: config.code, value: config.values.first ?? "")
                self.selectedConfig.append(newSelectedVariant)
            }
        }
        
        self.reloadUI()
        self.delegate?.didSelectVariant(variants: self.selectedConfig)
    }
    
    private func reloadUI() {
        for view in allConfigView.subviews {
            view.removeFromSuperview()
        }
        
        listAllChipButtons.removeAll()
        
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
                        let chipButton = VariantButton()
                        chipButton.addTarget(self, action: #selector(didSelectVariant(_:)), for: .touchUpInside)
                        chipButton.updateVariant(SelectedVariant(attributeCode: configuration.code, value: value))
                        self.listAllChipButtons.append(chipButton)
                        
                        let code = configuration.code
                        if let selectedConfig = self.selectedConfig.first(where: { selectedConfig in
                            return selectedConfig.attributeCode == code
                        }) {
                            if selectedConfig.value == value {
                                chipButton.setState(.selected)
                            } else {
                                chipButton.setState(.normmal)
                            }
                        }
                        
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
    
    @objc private func didSelectVariant(_ sender: VariantButton) {
        guard let newVariant = sender.variantValue else { return }
        
        for variantButton in self.listAllChipButtons {
            if variantButton.variantValue?.attributeCode == newVariant.attributeCode {
                variantButton.setState(.normmal)
            }
        }
        
        if let index = self.selectedConfig.firstIndex(where: { variantValue in
            return variantValue.attributeCode == newVariant.attributeCode
        }) {
            self.selectedConfig[index] = newVariant
            sender.setState(.selected)
            
            delegate?.didSelectVariant(variants: self.selectedConfig)
        }
    }
    
//    private func isNewConfigAvailable(_ newSelect: SelectedVariant) -> Bool {
//        var newSelectedVariants = selectedConfig
//
//        var index = 0
//        for variant in newSelectedVariants {
//            if variant.attributeCode == newSelect.attributeCode {
//                newSelectedVariants[index] = newSelect
//                return self.configurationProduct?.isMatchingWithVariants(newSelectedVariants) ?? false
//            }
//
//            index += 1
//        }
//
//        return false
//    }
}
