//
//  ProductCollectionViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 13/11/2022.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let tagsViewStack       = UIView()
    let starView            = UILabel()
    let sourcePriceLabel    = DiscountLabel()
    let discountValue       = DiscountValueView()
    let truePriceLabel      = UILabel()
    let variantMark         = UILabel()
    
    private var productData : ProductDataSource?
    var delegate            : ProductCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.backgroundColor = kBackgroundColor

        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        self.contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().offset(15)
            make.height.equalTo(self.contentView.snp.width)
        }
        
//        productTitleLabel.text = ""
//        productTitleLabel.numberOfLines = 0
//        productTitleLabel.font = getCustomFont(size: 13, name: .regular)
//        productTitleLabel.textColor = kDefaultTextColor
//        productTitleLabel.numberOfLines = 0
//        self.contentView.addSubview(productTitleLabel)
//        productTitleLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(packageImage.snp.right).offset(12)
//            make.top.equalTo(packageImage)
//            make.right.equalToSuperview().offset(-16)
//        }
//
//        self.contentView.addSubview(tagsViewStack)
//        tagsViewStack.snp.makeConstraints { make in
//            make.top.equalTo(productTitleLabel.snp.bottom)
//            make.left.right.equalTo(productTitleLabel)
//            make.height.equalTo(14)
//        }
//
//        truePriceLabel.text = "$ 10.00"
//        truePriceLabel.textColor = kDefaultTextColor
//        truePriceLabel.font = getCustomFont(size: 13, name: .extraBold)
//        self.contentView.addSubview(truePriceLabel)
//        truePriceLabel.snp.makeConstraints { (make) in
//            make.bottom.equalTo(packageImage.snp.bottom)
//            make.left.equalTo(productTitleLabel)
//        }
//
//        starView.text = "★ 4.5"
//        starView.font = getCustomFont(size: 11, name: .regular)
//        starView.textColor = kDefaultTextColor
//        self.contentView.addSubview(starView)
//        starView.snp.makeConstraints { make in
//            make.centerY.equalTo(truePriceLabel)
//            make.right.equalTo(productTitleLabel)
//        }
//
//        contentView.addSubview(discountValue)
//        discountValue.snp.makeConstraints { make in
//            make.left.equalTo(productTitleLabel)
//            make.bottom.equalTo(truePriceLabel.snp.top).offset(-5)
//        }
//
//        sourcePriceLabel.text = "$ 20.00"
//        sourcePriceLabel.setTextColor(kDefaultTextColor)
//        sourcePriceLabel.font = getCustomFont(size: 11, name: .semiBold)
//        self.contentView.addSubview(sourcePriceLabel)
//        sourcePriceLabel.snp.makeConstraints { (make) in
//            make.bottom.equalTo(truePriceLabel.snp.top).offset(-5)
//            make.left.equalTo(discountValue.snp.right).offset(4)
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDataSource(_ cellData: ProductDataSource) {
        
        self.productData = cellData
        
        if let imageURL = URL.init(string: cellData.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        self.productTitleLabel.text = cellData.name
//        self.loadTagsContents(cellData)
        
        self.sourcePriceLabel.text = getMoneyFormat(cellData.customRegularPrice)
        self.truePriceLabel.text = getMoneyFormat(cellData.customFinalPrice)
        self.sourcePriceLabel.isHidden = (cellData.customRegularPrice == cellData.customFinalPrice)
        
//        if cellData.discountPercent > 0 {
//            self.discountValue.isHidden = false
//            self.discountValue.contentLabel.text = String(format: "-%.f%%", cellData.discountPercent )
//        } else {
//            self.discountValue.isHidden = true
//        }
        
        variantMark.isHidden = (cellData.type == .simple) || cellData.configurableOptions.isEmpty
        if cellData.configurableOptions.count == 1 {
            variantMark.text = String(format: "  1 variant  ")
        } else {
            variantMark.text = String(format: "  %ld variants  ", cellData.configurableOptions.count)
        }
    }
    
    private func loadTagsContents(_ cellData: ProductDataSource) {
        for subView in tagsViewStack.subviews {
            subView.removeFromSuperview()
        }
        
        var lastView : UIView?
        switch cellData.featureType {
        case .ecom:
            let newChipView = ChipView.init(title: "Physical Product")
            tagsViewStack.addSubview(newChipView)
            newChipView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
            }
            
            if let lastView = lastView {
                newChipView.snp.makeConstraints { make in
                    make.left.equalTo(lastView.snp.right).offset(4)
                }
            } else {
                newChipView.snp.makeConstraints { make in
                    make.left.equalTo(self.productTitleLabel)
                }
            }
            lastView = newChipView
        case .ecom_booking:
            let newChipView = ChipView.init(title: "Virtual Product")
            tagsViewStack.addSubview(newChipView)
            newChipView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
            }
            if let lastView = lastView {
                newChipView.snp.makeConstraints { make in
                    make.left.equalTo(lastView.snp.right).offset(4)
                }
            } else {
                newChipView.snp.makeConstraints { make in
                    make.left.equalTo(self.productTitleLabel)
                }
            }
            lastView = newChipView
        }
        
        if let unitName = cellData.unit?.name {
            let newChipView = ChipView.init(title: unitName)
            tagsViewStack.addSubview(newChipView)
            newChipView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
            }
            if let lastView = lastView {
                newChipView.snp.makeConstraints { make in
                    make.left.equalTo(lastView.snp.right).offset(4)
                }
            } else {
                newChipView.snp.makeConstraints { make in
                    make.left.equalTo(self.productTitleLabel)
                }
            }
            lastView = newChipView
        }
    }
}
