//
//  ProductTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift

class ProductTableViewCell: UITableViewCell {
    
    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let tagsViewStack       = UIView()
    let starView            = UILabel()
    let sourcePriceLabel    = DiscountLabel()
    let discountValue       = DiscountValueView()
    let truePriceLabel      = UILabel()
    let variantMark         = UILabel()
    let addToWishlistBtn    = UIButton()
    
    private var productData : ProductDataSource?
    private let disposeBag  = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = kBackgroundColor

        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        self.contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(106)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
        }
        
        productTitleLabel.text = ""
        productTitleLabel.font = getCustomFont(size: 13, name: .regular)
        productTitleLabel.textColor = kDefaultTextColor
        productTitleLabel.numberOfLines = 2
        self.contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(12)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.contentView.addSubview(tagsViewStack)
        tagsViewStack.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom)
            make.left.right.equalTo(productTitleLabel)
            make.height.equalTo(14)
        }
        
        truePriceLabel.text = "$ 10.00"
        truePriceLabel.textColor = kDefaultTextColor
        truePriceLabel.font = getCustomFont(size: 13, name: .extraBold)
        self.contentView.addSubview(truePriceLabel)
        truePriceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(packageImage.snp.bottom)
            make.left.equalTo(productTitleLabel)
        }
        
        contentView.addSubview(discountValue)
        discountValue.snp.makeConstraints { make in
            make.left.equalTo(productTitleLabel)
            make.bottom.equalTo(truePriceLabel.snp.top).offset(-5)
        }
        
        sourcePriceLabel.text = "$ 20.00"
        sourcePriceLabel.setTextColor(kDefaultTextColor)
        sourcePriceLabel.font = getCustomFont(size: 11, name: .semiBold)
        self.contentView.addSubview(sourcePriceLabel)
        sourcePriceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(truePriceLabel.snp.top).offset(-5)
            make.left.equalTo(discountValue.snp.right).offset(4)
        }
        
        addToWishlistBtn.setBackgroundImage(UIImage.init(named: "wishlist_active_btn"), for: .selected)
        addToWishlistBtn.setBackgroundImage(UIImage.init(named: "wishlist_inactive_btn"), for: .normal)
        addToWishlistBtn.addTarget(self, action: #selector(addToWishListButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(addToWishlistBtn)
        addToWishlistBtn.snp.makeConstraints { make in
            make.centerY.equalTo(truePriceLabel)
            make.right.equalTo(productTitleLabel)
            make.height.width.equalTo(16)
        }
        
        starView.text = "★ 4.5"
        starView.font = getCustomFont(size: 11, name: .regular)
        starView.textColor = kDefaultTextColor
        self.contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.centerY.equalTo(truePriceLabel)
            make.right.equalTo(addToWishlistBtn.snp.left).offset(-16)
        }
//        variantMark.isHidden = true
//        variantMark.backgroundColor = kRedHightLightColor
//        variantMark.textColor = .white
//        variantMark.layer.cornerRadius = 8
//        variantMark.layer.masksToBounds = true
//        variantMark.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
//        self.contentView.addSubview(variantMark)
//        variantMark.snp.makeConstraints { make in
//            make.top.equalTo(sourcePriceLabel.snp.bottom).offset(5)
//            make.right.bottom.equalToSuperview()
//            make.height.equalTo(35)
//        }

        _AppCoreData.wishListProduct
            .observe(on: MainScheduler.instance)
            .subscribe { wishList in
                
                guard let wishList = wishList.element else {return}
                guard let productData = self.productData else {
                    return
                }
                
                if wishList.contains(productData) {
                    self.addToWishlistBtn.isSelected = true
                } else {
                    self.addToWishlistBtn.isSelected = false
                }
            }
            .disposed(by: disposeBag)
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
        self.loadTagsContents(cellData)
        
        self.sourcePriceLabel.text = getMoneyFormat(cellData.customRegularPrice)
        self.truePriceLabel.text = getMoneyFormat(cellData.customFinalPrice)
        self.sourcePriceLabel.isHidden = (cellData.customRegularPrice == cellData.customFinalPrice)
        
        if cellData.discountPercent > 0 {
            self.discountValue.isHidden = false
            self.discountValue.contentLabel.text = String(format: "-%.f%%", cellData.discountPercent )
        } else {
            self.discountValue.isHidden = true
        }
        
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
    
    @objc private func addToWishListButtonTapped() {
        self.addToWishlistBtn.isSelected = !self.addToWishlistBtn.isSelected
        
        guard let productData = self.productData else {
            return
        }
        
        var wishList = _AppCoreData.wishListProduct.value
        if self.addToWishlistBtn.isSelected {
            wishList.append(productData)
        } else {
            wishList.removeAll { savedProduct in
                return savedProduct == productData
            }
        }
        _AppCoreData.wishListProduct.accept(wishList)
    }
}
