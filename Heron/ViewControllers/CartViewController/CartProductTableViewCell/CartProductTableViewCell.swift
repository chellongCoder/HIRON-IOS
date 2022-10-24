//
//  ProductTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol CartProductCellDelegate: AnyObject {
    func removeItemFromCart(_ index: IndexPath)
    func modifyCheckoutList(_ index: IndexPath)
    func didUpdateItemQuanlity(_ index: IndexPath, newValue: Int)
}

class CartProductTableViewCell: UITableViewCell {
    
    let checkboxButton      = UIButton()
    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let tagsContent         = UILabel()
    let priceLabel          = DiscountLabel()
    let priceDiscount       = UILabel()
    
    let minusBtn            = UIButton()
    let quantityTxt         = UITextField()
    let plusBtn             = UIButton()
    
    private var quantityValue   = 0
    
    private var cartItemData : CartItemDataSource? {
        didSet {
            checkboxButton.isSelected = cartItemData?.isSelected ?? false
        }
    }
    private var indexPath   : IndexPath?
    var delegate            : CartProductCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }

        checkboxButton.tintColor = kPrimaryColor
        checkboxButton.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkboxButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.imageView?.contentMode = .scaleAspectFit
        checkboxButton.addTarget(self, action: #selector(modifyCheckoutList(button:)), for:.touchUpInside)
        contentView.addSubview(checkboxButton)
        checkboxButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(35)
        }
        
        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalTo(checkboxButton.snp.right).offset(10)
            make.width.height.equalTo(120)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
        }
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 0
        productTitleLabel.font = getFontSize(size: 16, weight: .medium)
        productTitleLabel.textColor = kDefaultTextColor
        productTitleLabel.numberOfLines = 0
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        tagsContent.text = ""
        tagsContent.numberOfLines = 0
        tagsContent.font = getFontSize(size: 12, weight: .regular)
        tagsContent.textColor = kDefaultTextColor
        contentView.addSubview(tagsContent)
        tagsContent.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(productTitleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-16)
        }
        
        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(tagsContent.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = "$ 20.00"
        priceLabel.setTextColor(kDisableColor)
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagsContent.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
        }
        
        checkboxButton.isSelected = cartItemData?.isSelected ?? false
        
        minusBtn.setBackgroundImage(UIImage.init(systemName: "minus.circle"), for: .normal)
        minusBtn.layer.cornerRadius = 15
        minusBtn.layer.masksToBounds = true
        minusBtn.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        contentView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.left.equalTo(productTitleLabel)
            make.height.width.equalTo(30)
        }
        
        plusBtn.setBackgroundImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        plusBtn.layer.cornerRadius = 15
        plusBtn.layer.masksToBounds = true
        plusBtn.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        contentView.addSubview(plusBtn)
        plusBtn.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.right.equalTo(productTitleLabel)
            make.height.width.equalTo(30)
        }
        
        quantityTxt.text = String(format: "%ld", self.quantityValue)
        quantityTxt.layer.borderWidth = 1
        quantityTxt.layer.borderColor = UIColor.lightGray.cgColor
        quantityTxt.textAlignment = .center
        quantityTxt.keyboardType = .numberPad
        quantityTxt.delegate = self
        contentView.addSubview(quantityTxt)
        quantityTxt.snp.makeConstraints { make in
            make.centerY.equalTo(minusBtn)
            make.height.equalTo(30)
            make.left.equalTo(minusBtn.snp.right).offset(5)
            make.right.equalTo(plusBtn.snp.left).offset(-5)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
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
        
        self.priceLabel.text = getMoneyFormat(cellData.product!.customRegularPrice)
        self.priceDiscount.text = getMoneyFormat(cellData.product!.customFinalPrice)
        self.priceLabel.isHidden = (cellData.product!.customRegularPrice == cellData.product!.customFinalPrice)
        
        self.quantityValue = cellData.quantity
        self.quantityTxt.text = String(format: "%ld", cellData.quantity)
        
        guard let productData = cellData.product else {return}
        var contentText = ""
        switch productData.featureType {
        case .ecom:
            contentText = "Physical Product"
        case .ecom_booking:
            contentText = "Virtual Product"
        }
        
        if let unitName = productData.unit?.name {
            contentText = String(format: "%@, %@", contentText, unitName)
        }
        
        if let brandName = productData.brand?.name {
            contentText = String(format: "%@, %@", contentText, brandName)
        }
        
        for (_, attribute) in productData.attributes {
            if let label = attribute.label {
                contentText = String(format: "%@, %@ %@", contentText, label, attribute.value ?? "")
            }
        }
        self.tagsContent.text = contentText
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
    
    @objc private func minusButtonTapped() {
        
        guard let indexPath = indexPath else {
            return
        }
        
        if self.quantityValue <= 1 {
            self.delegate?.removeItemFromCart(indexPath)
            return
        }
        self.quantityValue -= 1
        quantityTxt.text = String(format: "%ld", self.quantityValue)
        self.updateItemQuanlity()
    }
    
    @objc private func plusButtonTapped() {
        if self.quantityValue >= 99999 {
            let alertVC = UIAlertController.init(title: NSLocalizedString("Oops!", comment: ""),
                                                 message: "Current limit quantity for every items is 99999",
                                                 preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
            self.quantityTxt.text = String(self.quantityValue)
            return
        }
        
        self.quantityValue += 1
        quantityTxt.text = String(format: "%ld", self.quantityValue)
        self.updateItemQuanlity()
    }
    
    private func updateItemQuanlity() {
        guard let indexPath = indexPath else {
            return
        }
        
        if self.quantityValue == 0 {
            delegate?.removeItemFromCart(indexPath)
        } else {
            delegate?.didUpdateItemQuanlity(indexPath, newValue: self.quantityValue)
        }
    }
}

extension CartProductTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let number = Int(quantityTxt.text ?? "0") ?? 0
        
        if number >= 99999 {
            let alertVC = UIAlertController.init(title: NSLocalizedString("Oops!", comment: ""),
                                                 message: "Current limit quantity for every items is 99999",
                                                 preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
            self.quantityTxt.text = String(self.quantityValue)
            return
        }
        
        self.quantityValue = number
        self.updateItemQuanlity()
    }
}
