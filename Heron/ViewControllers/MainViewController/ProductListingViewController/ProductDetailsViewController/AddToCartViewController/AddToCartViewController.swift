//
//  AddToCartViewController.swift
//  Heron
//
//  Created by Luu Luc on 10/05/2022.
//

import UIKit
import RxCocoa
import RxSwift

class AddToCartViewController: UIViewController {
    
    private let viewModel = AddToCartViewModel()
    private let contentView = UIView()
    
    private let closeBtn    = UIButton()
    
    let packageImage        = UIImageView()
    let discountPercent     = UILabel()
    let productTitleLabel   = UILabel()
    let priceLabel          = UILabel()
    let priceDiscount       = UILabel()
    
    private let variantView     = ConfigurationProductVariantView()
    
    let addToCartBtn        = UIButton()
    
    let minusBtn            = UIButton()
    let quantityTxt         = UITextField()
    let plusBtn             = UIButton()
    
    var productData         : ProductDataSource?
    var simpleProductData   : ProductDataSource?
    var quantityValue       = 1
    
    private let disposeBag  = DisposeBag()
    
    init(productData: ProductDataSource) {
        super.init(nibName: nil, bundle: nil)
        self.productData = productData
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.variantView.delegate = self
            self.variantView.setConfigurationProduct(productData, isAllowToChange: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        self.viewModel.controller = self
        
        let dismissTouch = UITapGestureRecognizer.init(target: self, action: #selector(closeButtonTapped))
        
        let transparentView = UIView()
        transparentView.addGestureRecognizer(dismissTouch)
        transparentView.backgroundColor = .lightGray
        transparentView.alpha = 0.3
        self.view.addSubview(transparentView)
        transparentView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = kPrimaryColor.cgColor
        contentView.alpha = 1.0
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(300)
            make.centerX.width.equalToSuperview()
        }
        
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.height.width.equalTo(40)
        }
        
        // Content UI
        packageImage.image = UIImage(named: "default-image")
        if let imageURL = URL.init(string: productData?.thumbnailUrl ?? "") {
            self.packageImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(18)
            make.width.height.equalTo(120)
        }
        
        discountPercent.text = "-50%"
        discountPercent.backgroundColor = .red
        discountPercent.textColor = .white
        discountPercent.layer.cornerRadius = 4
        discountPercent.font = getFontSize(size: 20, weight: .heavy)
        contentView.addSubview(discountPercent)
        discountPercent.snp.makeConstraints { make in
            make.top.equalTo(packageImage.snp.top).offset(-5)
            make.right.equalTo(packageImage).offset(5)
        }
        
        if (productData?.discountPercent ?? 0) > 0 {
            self.discountPercent.isHidden = false
            self.discountPercent.text = String(format: "-%.f%%", productData?.discountPercent ?? 0 )
        } else {
            self.discountPercent.isHidden = true
        }
        
        productTitleLabel.text = productData?.name ?? ""
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
                
        priceDiscount.text = String(format: "$%.2f", productData?.customFinalPrice ?? 0.0)
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = String(format: "$%.2f", productData?.customRegularPrice ?? 0.0)
        priceLabel.textColor = kDisableColor
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
        }
                
        contentView.addSubview(variantView)
        variantView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(priceLabel.snp.bottom).offset(15)
            make.top.greaterThanOrEqualTo(packageImage.snp.bottom).offset(15)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        let quantityLabel = UILabel()
        quantityLabel.text = "Quantity :"
        quantityLabel.font = getFontSize(size: 16, weight: .medium)
        quantityLabel.textColor = kDefaultTextColor
        contentView.addSubview(quantityLabel)
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(variantView.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.left.equalToSuperview().offset(20)
        }
        
        minusBtn.setBackgroundImage(UIImage.init(systemName: "minus.circle"), for: .normal)
        minusBtn.layer.cornerRadius = 15
        minusBtn.layer.masksToBounds = true
        minusBtn.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        contentView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints { make in
            make.centerY.equalTo(quantityLabel)
            make.left.equalTo(quantityLabel.snp.right)
            make.height.width.equalTo(30)
        }
        
        
        plusBtn.setBackgroundImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        plusBtn.layer.cornerRadius = 15
        plusBtn.layer.masksToBounds = true
        plusBtn.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        contentView.addSubview(plusBtn)
        plusBtn.snp.makeConstraints { make in
            make.centerY.equalTo(quantityLabel)
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
            make.centerY.equalTo(quantityLabel)
            make.height.equalTo(40)
            make.left.equalTo(minusBtn.snp.right).offset(5)
            make.right.equalTo(plusBtn.snp.left).offset(-5)
        }
        
        addToCartBtn.setTitle("Add to cart", for: .normal)
        addToCartBtn.backgroundColor = kPrimaryColor
        addToCartBtn.layer.cornerRadius = 8
        addToCartBtn.addTarget(self, action: #selector(addCartButtonTapped), for: .touchUpInside)
        contentView.addSubview(addToCartBtn)
        addToCartBtn.snp.makeConstraints { make in
            make.top.equalTo(quantityTxt.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview().offset(-50)
        }
        
        quantityTxt.rx.controlEvent(.editingChanged)
            .withLatestFrom(quantityTxt.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                let number = Int(text) ?? 0
                self.quantityValue = number
            })
            .disposed(by: disposeBag)
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.contentView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func closeButtonTapped() {
        UIView.animate(withDuration: 0.5) {
            self.contentView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(300)
            }
            self.view.layoutIfNeeded()
        } completion: { isSuccess in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc private func minusButtonTapped() {
        if self.quantityValue <= 1 {return}
        self.quantityValue -= 1
        quantityTxt.text = String(format: "%ld", self.quantityValue)
    }
    
    @objc private func plusButtonTapped() {
        if self.quantityValue >= 99 {return}
        self.quantityValue += 1
        quantityTxt.text = String(format: "%ld", self.quantityValue)
    }
    
    @objc func addCartButtonTapped() {
        
        if let simpleProductData = simpleProductData {
            simpleProductData.quantity = self.quantityValue
            
            let cartVC = CartViewController.sharedInstance
            cartVC.addProductToCart(simpleProductData)
            self.dismiss(animated: true, completion: nil)
            
            return
        }
        
        if let productData = productData {
            productData.quantity = self.quantityValue
            
            let cartVC = CartViewController.sharedInstance
            cartVC.addProductToCart(productData)
            self.dismiss(animated: true, completion: nil)
            
            return
        }
    }
}

extension AddToCartViewController : ProductVariantDelegate {
    func didSelectVariant(variants: [SelectedVariant]) {
        guard let listChilren : [ProductDataSource] = self.productData?.children else {return}
        
        if self.productData?.type == .simple {
            return
        }
        
        if let matchedSimpleProduct = listChilren.first(where: { simpleProduct in
            return simpleProduct.isMatchingWithVariants(variants)
        }) {
            // Load new UI
            self.productTitleLabel.text = matchedSimpleProduct.name
            self.priceDiscount.text = String(format: "$%.2f", matchedSimpleProduct.customFinalPrice)
            self.priceLabel.text = String(format: "#%.2f", matchedSimpleProduct.customRegularPrice)
            
            self.addToCartBtn.isUserInteractionEnabled = true
            self.addToCartBtn.backgroundColor = kPrimaryColor
            self.simpleProductData = matchedSimpleProduct
        } else {
            self.addToCartBtn.isUserInteractionEnabled = false
            self.addToCartBtn.backgroundColor = kDisableColor
            self.simpleProductData = nil
        }
    }
}
