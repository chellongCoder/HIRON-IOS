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
//    let tagsContent         = UILabel()
    var volumeContent       : ChipViewDropDown?
//    let priceLabel          = DiscountLabel()
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

        checkboxButton.tintColor = kPrimaryColor
        checkboxButton.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkboxButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.imageView?.contentMode = .scaleAspectFit
        checkboxButton.addTarget(self, action: #selector(modifyCheckoutList(button:)), for:.touchUpInside)
        self.contentView.addSubview(checkboxButton)
        checkboxButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(16)
        }
        
        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        self.contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(21)
            make.left.equalTo(checkboxButton.snp.right).offset(14)
            make.width.equalTo(80)
            make.height.equalTo(98)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 2
        productTitleLabel.font = getCustomFont(size: 11, name: .regular)
        productTitleLabel.textColor = kCustomTextColor
        self.contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-53)
        }
        
//        tagsContent.text = ""
//        tagsContent.numberOfLines = 0
//        tagsContent.font = getCustomFont(size: 11, name: .semiBold)
//        tagsContent.textColor = kDefaultTextColor
//        self.contentView.addSubview(tagsContent)
//        tagsContent.snp.makeConstraints { (make) in
//            make.left.equalTo(packageImage.snp.right).offset(16)
//            make.top.equalTo(productTitleLabel.snp.bottom).offset(8)
//            make.right.equalToSuperview().offset(-16)
//        }
        
        volumeContent = ChipViewDropDown.init(title: "")
        self.contentView.addSubview(volumeContent!)
        volumeContent!.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.top.equalTo(productTitleLabel.snp.bottom).offset(8)
//            make.top.equalTo(tagsContent.snp.bottom).offset(8)
        }
        
        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kDefaultTextColor
        priceDiscount.font = getCustomFont(size: 13, name: .extraBold)
        self.contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.bottom.equalTo(packageImage.snp.bottom)
            make.right.equalToSuperview().offset(-16)
        }
        
//        priceLabel.text = "$ 20.00"
//        priceLabel.setTextColor(kDisableColor)
//        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
//        self.contentView.addSubview(priceLabel)
//        priceLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(tagsContent.snp.bottom).offset(10)
//            make.left.equalTo(priceDiscount.snp.right).offset(5)
//        }
        
        checkboxButton.isSelected = cartItemData?.isSelected ?? false
        
        minusBtn.setTitle("-", for: .normal)
        minusBtn.setTitleColor(kDefaultTextColor, for: .normal)
        minusBtn.layer.cornerRadius = 10
        minusBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        minusBtn.layer.borderWidth = 0.7
        minusBtn.layer.borderColor = kDisableColor.cgColor
        minusBtn.layer.masksToBounds = true
        minusBtn.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints { make in
            make.centerY.equalTo(priceDiscount)
            make.left.equalTo(packageImage.snp.right).offset(16)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        
        quantityTxt.text = String(format: "%ld", self.quantityValue)
        quantityTxt.font = getCustomFont(size: 11, name: .medium)
        quantityTxt.layer.borderWidth = 0.7
        quantityTxt.layer.borderColor = kDisableColor.cgColor
        quantityTxt.textAlignment = .center
        quantityTxt.keyboardType = .numberPad
        quantityTxt.delegate = self
        self.contentView.addSubview(quantityTxt)
        quantityTxt.snp.makeConstraints { make in
            make.centerY.equalTo(minusBtn)
            make.left.equalTo(minusBtn.snp.right).offset(-0.5)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        
        plusBtn.setTitle("+", for: .normal)
        plusBtn.setTitleColor(kDefaultTextColor, for: .normal)
        plusBtn.layer.cornerRadius = 10
        plusBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        plusBtn.layer.borderWidth = 0.7
        plusBtn.layer.borderColor = kDisableColor.cgColor
        plusBtn.layer.masksToBounds = true
        plusBtn.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(plusBtn)
        plusBtn.snp.makeConstraints { make in
            make.centerY.equalTo(priceDiscount)
            make.left.equalTo(quantityTxt.snp.right).offset(-0.5)
            make.height.equalTo(20)
            make.width.equalTo(30)
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
        
//        self.priceLabel.text = getMoneyFormat(cellData.product!.customRegularPrice)
        self.priceDiscount.text = getMoneyFormat(cellData.product?.customFinalPrice ?? 0.0)
//        self.priceLabel.isHidden = (cellData.product!.customRegularPrice == cellData.product!.customFinalPrice)
        
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
        
//        self.tagsContent.text = contentText
        
        for (_, attribute) in productData.attributes {
            if let label = attribute.label {
                self.volumeContent?.textLabel.text = String(format: "%@ - %@", label, attribute.value ?? "")
            }
        }
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
