//
//  MyOrderCell.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit
import RxSwift

class MyOrderCell: UITableViewCell {
    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let tagContentLabel     = UILabel()
    let priceLabel          = UILabel()
    let priceDiscount       = UILabel()
    
    private let disposeBag  = DisposeBag()
    
    private var cartItemData : CartItemDataSource? = nil {
        didSet {
//            checkboxButton.isSelected = cartItemData?.isSelected ?? false
        }
    }
    private var indexPath   : IndexPath? = nil
    var delegate            : CartProductCellDelegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white

        let contentView = UIView()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(120)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 0
        productTitleLabel.font = getFontSize(size: 14, weight: .regular)
        productTitleLabel.textColor = kDefaultTextColor
        productTitleLabel.numberOfLines = 0
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        tagContentLabel.backgroundColor = UIColor.init(hexString: "F0F0F0")
        tagContentLabel.textColor = kDefaultTextColor
        tagContentLabel.font = getFontSize(size: 12, weight: .regular)
        tagContentLabel.numberOfLines = 0
        contentView.addSubview(tagContentLabel)
        tagContentLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom)
            make.left.right.equalTo(productTitleLabel)
        }
        
        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(tagContentLabel.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = "$ 20.00"
        priceLabel.textColor = kDisableColor
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagContentLabel.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: CartItemDataSource, indexPath: IndexPath) {
        
        self.cartItemData = cellData
        self.indexPath = indexPath
        
        self.productTitleLabel.text = cellData.product?.name
        if let imageURL = URL.init(string: cellData.product?.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        self.priceLabel.text = String(format: "$%ld", cellData.product?.customFinalPrice ?? 0.0)
        self.priceDiscount.text = String(format: "$%ld", cellData.product?.finalPrice ?? 0.0)
    
    }
    
    func setDataSource(_ cellData: OrderItems, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        self.productTitleLabel.text = cellData.name
        if let imageURL = URL.init(string: cellData.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        self.priceLabel.text = String(format: "$%ld", cellData.regularPrice ?? 0.0)
        self.priceDiscount.text = String(format: "$%ld", cellData.finalPrice ?? 0.0)
        
        let attributeID : [String] = (cellData.attributes ?? []).filter({ attribute in
            return attribute.key == "Color" || attribute.key == "Size" || attribute.key == "weight"
        }).map { $0.value ?? "" }
        self.tagContentLabel.text = attributeID.joined(separator:" - ")
    }
    
    @objc private func removeButtonTapped() {
        if let indexPath = indexPath {
            delegate?.removeItemFromCart(indexPath)
        }
    }
    
    @objc private func modifyCheckoutList(button: UIButton) {
        if let indexPath = indexPath {
            delegate?.modifyCheckoutList(indexPath)
        }
    }
    
 
}
