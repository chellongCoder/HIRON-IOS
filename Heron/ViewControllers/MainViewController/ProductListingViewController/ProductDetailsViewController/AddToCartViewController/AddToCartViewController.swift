//
//  AddToCartViewController.swift
//  Heron
//
//  Created by Luu Luc on 10/05/2022.
//

import UIKit

class AddToCartViewController: UIViewController {
    
    private let viewModel = AddToCartViewModel()
    private let contentView = UIView()
    
    private let closeBtn    = UIButton()
    
    let packageImage        = UIImageView()
    let discountPercent     = UILabel()
    let productTitleLabel   = UILabel()
    let priceLabel          = UILabel()
    let priceDiscount       = UILabel()
    let addToCartBtn        = UIButton()
    
    var productData         : ProductDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .clear
        
        self.viewModel.controller = self
        
        let transparentView = UIView()
        transparentView.backgroundColor = .lightGray
        transparentView.alpha = 0.3
        self.view.addSubview(transparentView)
        transparentView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
        
        contentView.backgroundColor = kBackgroundColor
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = kCyanTextColor?.cgColor
        contentView.alpha = 1.0
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.width.equalToSuperview()
        }
        
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.height.width.equalTo(40)
        }
        
        //Content UI
        packageImage.image = UIImage(named: "default-image")
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
        
        productTitleLabel.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        productTitleLabel.numberOfLines = 0
        productTitleLabel.font = getFontSize(size: 16, weight: .medium)
        productTitleLabel.textColor = kSpaceCadetColor
        productTitleLabel.numberOfLines = 0
        contentView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
                
        priceDiscount.text = "$ 10.00"
        priceDiscount.textColor = kNeonFuchsiaColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel)
        }
        
        priceLabel.text = "$ 20.00"
        priceLabel.textColor = kGrayTextColor
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
        }
        
        addToCartBtn.setTitle("Add to cart", for: .normal)
        addToCartBtn.backgroundColor = kCyanTextColor
        addToCartBtn.layer.cornerRadius = 8
        addToCartBtn.addTarget(self, action: #selector(addCartButtonTapped), for: .touchUpInside)
        contentView.addSubview(addToCartBtn)
        addToCartBtn.snp.makeConstraints { make in
            make.top.equalTo(priceDiscount.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.left.equalTo(productTitleLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-50)
        }
        
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addCartButtonTapped() {
        guard let productData = productData else {
            return
        }

        let cartVC = CartViewController.sharedInstance
        cartVC.addProductToCart(productData)
        self.dismiss(animated: true, completion: nil)
    }
}