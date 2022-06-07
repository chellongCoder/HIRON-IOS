//
//  ProductTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol CartProductCellDelegate {
    func removeItemFromCart(_ index: IndexPath)
    func modifyCheckoutList(_ index: IndexPath)
    func didUpdateItemQuanlity(_ index: IndexPath, newValue: Int)
}

class CartProductTableViewCell: UITableViewCell {
    
    let checkboxButton      = UIButton()
    let packageImage        = UIImageView()
    let productTitleLabel   = UILabel()
    let priceLabel          = UILabel()
    let priceDiscount       = UILabel()
    
    let minusBtn            = UIButton()
    let quantityTxt         = UITextField()
    let plusBtn             = UIButton()
    
    private var quantityValue   = 0
    private let disposeBage = DisposeBag()
    
    private var cartItemData : CartItemDataSource? = nil {
        didSet {
            checkboxButton.isSelected = cartItemData?.isSelected ?? false
        }
    }
    private var indexPath   : IndexPath? = nil
    var delegate            : CartProductCellDelegate? = nil
    
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
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
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
        
        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = "$ 20.00"
        priceLabel.textColor = kDisableColor
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
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
        contentView.addSubview(quantityTxt)
        quantityTxt.snp.makeConstraints { make in
            make.centerY.equalTo(minusBtn)
            make.height.equalTo(30)
            make.left.equalTo(minusBtn.snp.right).offset(5)
            make.right.equalTo(plusBtn.snp.left).offset(-5)
        }

        quantityTxt.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe ({ [unowned self] _ in
                
                let number = Int(quantityTxt.text ?? "0") ?? 0
                if (number == 0) {return}
                
                self.quantityValue = number
                self.updateItemQuanlity()
            })
            .disposed(by: disposeBage)
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
        
        self.priceLabel.text = String(format: "$%ld", cellData.product!.regularPrice)
        self.priceDiscount.text = String(format: "$%ld", cellData.product!.finalPrice)
        
        self.quantityValue = cellData.quantity
        self.quantityTxt.text = String(format: "%ld", cellData.quantity)
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
        if self.quantityValue <= 1 {return}
        self.quantityValue -= 1
        quantityTxt.text = String(format: "%ld", self.quantityValue)
        self.updateItemQuanlity()
    }
    
    @objc private func plusButtonTapped() {
        if self.quantityValue >= 99 {return}
        self.quantityValue += 1
        quantityTxt.text = String(format: "%ld", self.quantityValue)
        self.updateItemQuanlity()
    }
    
    private func updateItemQuanlity() {
        guard let indexPath = indexPath else {
            return
        }

        delegate?.didUpdateItemQuanlity(indexPath, newValue: self.quantityValue)
    }
}
