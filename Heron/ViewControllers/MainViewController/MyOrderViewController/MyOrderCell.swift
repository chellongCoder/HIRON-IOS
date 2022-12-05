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
    let tagContentLabel     = ChipView(title: "")
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
        packageImage.contentMode = .scaleAspectFit
        packageImage.clipsToBounds = true
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(50)
            make.height.equalTo(61)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 0
        productTitleLabel.font = getCustomFont(size: 11, name: .regular)
        productTitleLabel.textColor = kCustomTextColor
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        tagContentLabel.textLabel.font = getCustomFont(size: 10, name: .regular)
        contentView.addSubview(tagContentLabel)
        tagContentLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(productTitleLabel)
        }
        
        countLabel.text = "x0"
        countLabel.textColor = kDefaultTextColor
        countLabel.font = getCustomFont(size: 13, name: .regular)
        countLabel.textAlignment = .right
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.bottom.equalTo(packageImage.snp.bottom)
            make.left.equalTo(tagContentLabel)
        }
        
        priceDiscount.text = "$0.00"
        priceDiscount.textColor = kDefaultTextColor
        priceDiscount.font = getCustomFont(size: 13, name: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.centerY.equalTo(countLabel)
            make.right.equalToSuperview().offset(-16)
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
        
        if !contentText.isEmpty {
            contentText.removeFirst()
        }
        
        self.tagContentLabel.textLabel.text = contentText
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
