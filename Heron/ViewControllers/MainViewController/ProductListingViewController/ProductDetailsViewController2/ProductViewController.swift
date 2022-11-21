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
                                     UIScrollViewDelegate, ProductVariantDelegate {
    private let viewModel               = ProductDetailsViewModel()

    var cartButtonItem                  : UIBarButtonItem?
    var shareButtonItem                 : UIBarButtonItem?
    var moreButtonItem                  : UIBarButtonItem?
    var heartItem                       : UIButton?
    var cartHub                         : BadgeHub?
    
    private let bannerImage             = UIImageView()
    private let tabView                 = TabViewProductDetail()
    private let topMediaView            = UIScrollView()
    private let pageControl             = UIPageControl()
    private let pagingView              = UILabel()
    private let topView                 = UIImageView()

    private let variantView             = ConfigurationProductVariantView()
    private let contentDescView         = UIView()
    let groupProductSizeCategory        = GroupProductCategory.init(title: "Size", categories: ["10ml", "5ml", "6ml"])
    let groupProductColorCategory       = GroupProductCategory.init(title: "Color", categories: ["red", "yellow", "blue", "green"])
    let stackTagView                    = StackTagView()
    let stackInfoView                   = StackInfoView()
    let addToCartBtn                    = UIButton()
    let descView                        = UIView()
    let shopView                        = ShopProductView()
    let footer                          = ProductDetailFooter()
    
    init(_ data: ProductDataSource) {
        super.init(nibName: nil, bundle: nil)
        viewModel.productDataSource.accept(data)
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

        self.topView.contentMode = .scaleAspectFill
        let image = UIImage(named: "banner_image4")
        self.topView.image = image      
        self.topView.layer.cornerRadius = 35/2
        self.topView.layer.masksToBounds = true
        self.topView.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        DispatchQueue.main.async {
            self.navigationItem.titleView = nil
        }
        
        ///TODO: UI footer
        self.view.addSubview(footer)
        footer.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
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
        moreButtonItem?.customView?.alpha = 0.0
        heartItem = UIButton(type: .custom)
        heartItem!.setImage(UIImage(systemName: "heart"), for: .normal)
        
        heartItem?.tintColor = kDefaultBlackColor

        self.navigationItem.rightBarButtonItems = [moreButtonItem!, shareButtonItem!,  cartButtonItem!]
        
        pageScroll.delegate = self
        pageScroll.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(footer.snp.top).offset(-10)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        pageScroll.addSubview(refreshControl)
        
        ///TODO: Top tab view
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0)
        }

        let staticHeight = (UIScreen.main.bounds.size.width)*1
        topMediaView.isPagingEnabled = true
        topMediaView.delegate = self
        topMediaView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(topMediaView)
        topMediaView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview()
            make.bottom.equalTo(topMediaView.snp.top).offset(staticHeight)
        }
        let width = UIScreen.main.bounds.size.width
        let size = CGSize(width: width, height: staticHeight)
        let listMediaLength = 5
        var index = 0

        for mediaData in 1...listMediaLength {
            
            let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
            
            let cell = ProductBannerView.init(frame: frame)
            if let imageURL = URL.init(string: mediaData.description ) {
                cell.bannerImage.setImage(url: imageURL, placeholder: UIImage(named: "banner_image4")!)
            }
            topMediaView.addSubview(cell)
            
            index += 1
        }
        
        self.contentView.addSubview(pagingView)
        pagingView.text = "1/5"
        pagingView.textColor = .white
        pagingView.textAlignment = .center
        pagingView.backgroundColor = .black
        pagingView.font = getCustomFont(size: 9, name: .regular)
        pagingView.layer.masksToBounds = true
        pagingView.layer.cornerRadius = 7
        pagingView.layer.opacity = 0.3
        pagingView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(topMediaView.snp.bottom).offset(-40)
            make.height.equalTo(14)
            make.width.equalTo(27)
        }
        
        self.pageControl.numberOfPages = listMediaLength
        topMediaView.contentSize = CGSize.init(width: CGFloat(listMediaLength)*(size.width), height: size.height)
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        
//        variantView.delegate = self
//        contentView.addSubview(variantView)
//        variantView.snp.makeConstraints { make in
//            make.left.equalToSuperview()
//            make.top.equalTo(pageControl.snp.bottom).offset(15)
//            make.centerX.equalToSuperview()
//        }

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
            make.top.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(30)
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
        nameProduct.font = getCustomFont(size: 16, name: .regular)
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
            make.top.equalTo(nameProduct.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(20)
        }
        
        /// TODO: UI product detail blur
        self.contentView.addSubview(contentDescView)
        contentDescView.snp.makeConstraints { (make) in
            make.top.equalTo(topMediaView.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(contentDescView.snp.width).multipliedBy(0.3)
        }

        /// TODO: UI Group category size
        self.contentView.addSubview(groupProductSizeCategory)
        groupProductSizeCategory.snp.makeConstraints { (make) in
            make.top.equalTo(contentDescView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        
        /// TODO: UI Group category size
        self.contentView.addSubview(groupProductColorCategory)
        groupProductColorCategory.snp.makeConstraints { (make) in
            make.top.equalTo(groupProductSizeCategory.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        /// TODO: UI spacer
        let spacer = SpacerView()
        self.contentView.addSubview(spacer)
        spacer.snp.makeConstraints { (make) in
            make.top.equalTo(groupProductColorCategory.snp.bottom).offset(60)
            make.height.equalTo(6)
            make.width.equalToSuperview()
        }

        /// TODO: UI shopview
        self.contentView.addSubview(shopView)
        shopView.snp.makeConstraints { (make) in
            make.top.equalTo(spacer.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        /// TODO: UI spacer
        let spacer2 = SpacerView()
        self.contentView.addSubview(spacer2)
        spacer2.snp.makeConstraints { (make) in
            make.top.equalTo(shopView.snp.bottom).offset(10)
            make.height.equalTo(6)
            make.width.equalToSuperview()
        }
        
        /// TODO: UI content description
        contentView.addSubview(descView)
        descView.snp.makeConstraints { make in
            make.left.right.equalTo(10)
            make.top.equalTo(spacer2.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
    }
    
    override func bindingData() {
        viewModel.productDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { productDataSource in
                guard let productDataA = productDataSource.element else {return}
                guard let productData = productDataA else {return}
                self.variantView.setConfigurationProduct(productData, isAllowToChange: false)
                self.loadContentDescView()
            }
            .disposed(by: disposeBag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false

        viewModel.reloadProductDetails()

    }

    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        self.topMediaView.setContentOffset(CGPoint(x: CGFloat(current)*view.frame.width, y: 0), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == self.topMediaView) {
            print("self.topMediaView")
        } else if(scrollView == self.pageScroll) {
            print("self.pageScroll")
            let contentOffset = scrollView.contentOffset
            if(contentOffset.y >= self.topMediaView.frame.size.height / 2) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.navigationItem.titleView = self.topView
                        self.pagingView.alpha = 0
                    } completion: { _ in
                        print("completed animate 1 up")
                    }

                    UIView.animate(withDuration: 2) {
                        
                        self.tabView.snp.remakeConstraints({ make in
                            make.left.equalToSuperview().offset(0)
                            make.top.equalToSuperview()
                            make.width.equalToSuperview()
                        })
                        
                        self.topMediaView.snp.remakeConstraints { make in
                            make.top.equalTo(64)
                            make.right.left.equalToSuperview()
                            make.bottom.equalTo(self.topMediaView.snp.top).offset(0)
                        }

                    } completion: { _ in
                        print("completed animate 2 up")
                    }
                }
            }
            else if(contentOffset.y < 0) {
                let staticHeight = (UIScreen.main.bounds.size.width)*1

                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.navigationItem.titleView = nil
                        self.pagingView.alpha = 0.3
                    } completion: { _ in
                        print("completed animate 1 down")
                    }

                    UIView.animate(withDuration: 2) {
                        
                        self.tabView.snp.remakeConstraints({ make in
                            make.left.equalToSuperview().offset(0)
                            make.top.equalToSuperview()
                            make.width.equalToSuperview()
                            make.height.equalTo(0)
                        })
                        
                        self.topMediaView.snp.remakeConstraints { make in
                            make.top.equalToSuperview()
                            make.right.left.equalToSuperview()
                            make.bottom.equalTo(self.topMediaView.snp.top).offset(staticHeight)
                        }
                    } completion: { _ in
                        print("completed animate 2 down")
                    }
                }
            }
            
        }
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth

        let page = lroundf(Float(fractionalPage))
        self.pageControl.currentPage = page
        pagingView.text = "\(page+1)/5"
    }

    @objc private func buyNowButtonTapped() {
        
    }
    
    func didSelectVariant(variants: [SelectedVariant]) {

    }

    private func loadContentDescView() {
        for subview in descView.subviews {
            subview.removeFromSuperview()
        }

        guard let productDataSource = self.viewModel.productDataSource.value else {return}

        var lastView: UIView?
        
        for content in productDataSource.desc {
            let titleLabel = UILabel()
            titleLabel.text = content.title
            titleLabel.textColor = kDefaultTextColor
            titleLabel.font = .boldSystemFont(ofSize: 13)
            self.descView.addSubview(titleLabel)
            
            if lastView != nil {
                titleLabel.snp.makeConstraints { make in
                    make.top.equalTo(lastView!.snp.bottom).offset(16)
                    make.centerX.left.equalToSuperview()
                }
            } else {
                titleLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.centerX.left.equalToSuperview()
                }
            }
            
            let contentLabel = UILabel()
            contentLabel.numberOfLines = 0
            contentLabel.attributedText = content.content.htmlAttributedString()
            contentLabel.textColor = UIColor.init(hexString: "172B4D")
            contentLabel.font = getCustomFont(size: 13, name: .regular)
            self.descView.addSubview(contentLabel)
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.centerX.left.equalToSuperview()
            }
            
            lastView = contentLabel
        }
        
        lastView?.snp.makeConstraints({ make in
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        })

    }
}
