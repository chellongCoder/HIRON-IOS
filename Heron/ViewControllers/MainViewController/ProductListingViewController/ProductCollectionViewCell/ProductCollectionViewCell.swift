//
//  ProductCollectionViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 13/11/2022.
//

import UIKit
import RxSwift

class ProductCollectionViewCell: UICollectionViewCell {

    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let tagsViewStack       = UIView()
    let starView            = LeftRightImageLabel.init(leftImage: UIImage.init(named: "star_icon"))
    let sourcePriceLabel    = DiscountLabel()
    let discountValue       = DiscountValueView()
    let truePriceLabel      = UILabel()
    let variantMark         = UILabel()
    let addToWishlistBtn    = ExtendedButton()
    
    private var productData : ProductDataSource?
    private let disposeBag  = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.backgroundColor = kBackgroundColor

        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        packageImage.layer.borderColor = kGrayColor.cgColor
        packageImage.layer.borderWidth = 2
        self.contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(self.contentView.snp.width)
        }
        
        productTitleLabel.text = ""
        productTitleLabel.numberOfLines = 2
        productTitleLabel.font = getCustomFont(size: 13, name: .regular)
        productTitleLabel.textColor = kDefaultTextColor
        self.contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(packageImage.snp.bottom).offset(8)
            make.left.equalTo(packageImage)
            make.right.equalToSuperview().offset(-34)
        }
        
        addToWishlistBtn.setBackgroundImage(UIImage.init(named: "wishlist_active_btn"), for: .selected)
        addToWishlistBtn.setBackgroundImage(UIImage.init(named: "wishlist_inactive_btn"), for: .normal)
        addToWishlistBtn.addTarget(self, action: #selector(addToWishListButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(addToWishlistBtn)
        addToWishlistBtn.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel)
            make.right.equalTo(packageImage)
            make.height.width.equalTo(32)
        }
        
        contentView.addSubview(discountValue)
        discountValue.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(6)
            make.left.equalTo(productTitleLabel)
        }
        
        sourcePriceLabel.text = "$ 20.00"
        sourcePriceLabel.setTextColor(kDefaultTextColor)
        sourcePriceLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.contentView.addSubview(sourcePriceLabel)
        sourcePriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(7)
            make.left.equalTo(discountValue.snp.right).offset(4)
        }
        
        truePriceLabel.text = "$ 10.00"
        truePriceLabel.textColor = kDefaultTextColor
        truePriceLabel.font = getCustomFont(size: 13, name: .extraBold)
        self.contentView.addSubview(truePriceLabel)
        truePriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(discountValue.snp.bottom).offset(2)
            make.left.equalTo(productTitleLabel)
//            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        starView.textLabel?.text = "4.5"
        starView.textLabel?.font = getCustomFont(size: 11, name: .regular)
        starView.textLabel?.textColor = kDefaultTextColor
        self.contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.centerY.equalTo(truePriceLabel)
            make.right.equalTo(packageImage)
            make.height.equalTo(11)
        }
        
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
        
        if _AppCoreData.wishListProduct.value.contains(cellData) {
            self.addToWishlistBtn.setSeleted(true)
        } else {
            self.addToWishlistBtn.setSeleted(false)
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
        self.addToWishlistBtn.setSeleted(!self.addToWishlistBtn.isSelected)
        
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
