//
//  ProductViewController.swift
//  Heron
//
//  Created by Longnn on 09/11/2022.
//

import UIKit
import RxSwift
import BadgeHub

class ProductDetailsViewController2: PageScrollViewController,
                                    UIScrollViewDelegate {
    
    var cartButtonItem                  : UIBarButtonItem?
    var shareButtonItem                 : UIBarButtonItem?
    var moreButtonItem                  : UIBarButtonItem?
    var heartItem                       : UIButton?
    
    var cartHub                         : BadgeHub?
    let bannerImage             = UIImageView()
    let contentDescView         = UIView()
    let groupProductSizeCategory    = GroupProductCategory.init(title: "Size", categories: ["10ml", "5ml", "6ml"])
    let groupProductColorCategory    = GroupProductCategory.init(title: "Color", categories: ["red", "yellow", "blue", "green"])
    let stackTagView            = StackTagView()
    let discountView            = DiscountView()
    let stackInfoView           = StackInfoView()

    

    init(_ data: ProductDataSource) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Buttons
    @objc private func cartButtonTapped() {
        _NavController.presentCartPage()
    }
    
    @objc private func filterButtonTapped() {
        _NavController.presentCartPage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackBtn()
        /// TODO: UI header
        cartButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "bagIcon"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(cartButtonTapped))
        cartButtonItem?.tintColor = kDefaultBlackColor
        self.cartHub = BadgeHub(barButtonItem: cartButtonItem!)
        self.cartHub?.setCircleColor(kRedHightLightColor, label: .white)
        self.cartHub?.setCircleBorderColor(.white, borderWidth: 1)
        self.cartHub?.setMaxCount(to: 99)
        self.cartHub?.setCount(10)
        self.cartHub?.pop()
        
        shareButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "shareIcon"),
                                                   style: .done,
                                              target: self,
                                              action: #selector(filterButtonTapped))
        shareButtonItem?.tintColor = kDefaultBlackColor
        
        moreButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "moreIcon"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(filterButtonTapped))
        moreButtonItem?.tintColor = kDefaultBlackColor
        
        heartItem = UIButton(type: .custom)
        heartItem!.setImage(UIImage(systemName: "heart"), for: .normal)
        
        heartItem?.tintColor = kDefaultBlackColor

        self.navigationItem.rightBarButtonItems = [moreButtonItem!, shareButtonItem!,  cartButtonItem!
        ]
        
        /// TODO: UI banner
        bannerImage.image = UIImage.init(named: "banner_image4")
        bannerImage.contentMode = .scaleAspectFill
        bannerImage.layer.masksToBounds = true
        self.view.addSubview(bannerImage)
        bannerImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview().offset(0)
            make.height.equalTo(bannerImage.snp.width).multipliedBy(1)
        }
        
        /// TODO: UI blurview product detail
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.contentMode = .scaleToFill
        blurEffectView.layer.cornerRadius = 8
        blurEffectView.layer.masksToBounds = true
        contentDescView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.left.equalToSuperview()
            make.width.equalToSuperview().offset(0)
            make.height.equalToSuperview().offset(0)
        }
        contentDescView.translatesAutoresizingMaskIntoConstraints = true
        contentDescView.layer.cornerRadius = 8
        contentDescView.layer.borderWidth = 0.5
        contentDescView.layer.borderColor = UIColor.lightGray.cgColor
        /// TODO: UI stack tag view
        contentDescView.addSubview(stackTagView)
        stackTagView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
        /// TODO: UI heart button
        contentDescView.addSubview(heartItem!)
        heartItem!.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        /// TODO: UI name product
        let nameProduct = UILabel()
        nameProduct.lineBreakMode = .byWordWrapping
        nameProduct.numberOfLines = 2
        nameProduct.text = "OptiBac Probiotics for Daily Wellbeing, 30 capsules OptiBac Probiotics for Daily Wellbeing, 30 capsules"
        nameProduct.font = getFontSize(size: 16, weight: .medium)
        nameProduct.textColor = UIColor.init(hexString: "424242")
        contentDescView.addSubview(nameProduct)
        nameProduct.snp.makeConstraints { (make) in
            make.top.equalTo(stackTagView.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-15)
        }

        /// TODO: UI stack info product
        contentDescView.addSubview(stackInfoView)
        stackInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(nameProduct.snp.bottom).offset(0)
            make.left.equalTo(10)
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(20)
        }
        
        /// TODO: UI product detail blur
        self.view.addSubview(contentDescView)
        contentDescView.snp.makeConstraints { (make) in
            make.top.equalTo(bannerImage.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(contentDescView.snp.width).multipliedBy(0.3)
        }

        /// TODO: UI Group category size
        self.view.addSubview(groupProductSizeCategory)
        groupProductSizeCategory.snp.makeConstraints { (make) in
            make.top.equalTo(contentDescView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        
        /// TODO: UI Group category size
        self.view.addSubview(groupProductColorCategory)
        groupProductColorCategory.snp.makeConstraints { (make) in
            make.top.equalTo(groupProductSizeCategory.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
