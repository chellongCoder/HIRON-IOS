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
    let priceLabel          = DiscountLabel()
    let priceDiscount       = UILabel()
    let countLabel          = UILabel()
    
    private let disposeBag  = DisposeBag()
    private var indexPath   : IndexPath?
    var delegate            : CartProductCellDelegate?
    
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
        
        priceLabel.text = "$0.00"
        priceLabel.setTextColor(kDisableColor)
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagContentLabel.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceDiscount.text = "$0.00"
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom)
            make.left.equalTo(productTitleLabel)
        }
        
        countLabel.text = "x0"
        countLabel.textColor = kDefaultTextColor
        countLabel.font = getFontSize(size: 12, weight: .regular)
        countLabel.textAlignment = .right
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceDiscount)
            make.right.equalTo(productTitleLabel)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ cellData: OrderItems, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        self.productTitleLabel.text = cellData.name
        if let imageURL = URL.init(string: cellData.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        
        self.priceLabel.text = getMoneyFormat(cellData.customRegularPrice)
        self.priceDiscount.text = getMoneyFormat(cellData.customFinalPrice)
        
        self.countLabel.text = String(format: "x%ld", cellData.quantity)
        
        var contentText = ""
        
        for (_, attribute) in cellData.metadata?.attributes ?? [:] {
            if let label = attribute.label {
                contentText = String(format: "%@, %@ %@", contentText, label, attribute.value ?? "")
            }
        }
        contentText.removeFirst()
        self.tagContentLabel.text = contentText
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
