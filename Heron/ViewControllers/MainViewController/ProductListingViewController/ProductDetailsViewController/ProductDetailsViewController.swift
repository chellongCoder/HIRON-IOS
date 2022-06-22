//
//  ProductDetailsViewController.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit
import RxSwift

class ProductDetailsViewController: BaseViewController,
                                    UIScrollViewDelegate {
    
    private let viewModel       = ProductDetailsViewModel()
    private let topMediaView    = UIScrollView()
    private let pageControl     = UIPageControl()
    
    private let packageTitle    = UILabel()
//    private let discountPercent = UILabel()
    private let starView        = UILabel()
    private let priceDiscount   = UILabel()
    private let priceLabel      = UILabel()
    private let contentDescView = UIView()
    
    private let addToCartBtn    = UIButton()
    private let cartHotInfo     = CartHotView()
//    private let disposeBag      = DisposeBag()

    init(_ data: ProductDataSource) {
        super.init(nibName: nil, bundle: nil)
        viewModel.productDataSource = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Details"
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let cartButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "cart"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(cartButtonTapped))
        self.navigationItem.rightBarButtonItem = cartButtonItem
        
        let staticHeight = (UIScreen.main.bounds.size.width)*0.5625
        topMediaView.isPagingEnabled = true
        topMediaView.delegate = self
        topMediaView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(topMediaView)
        topMediaView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview()
            make.bottom.equalTo(topMediaView.snp.top).offset(staticHeight + 50)
        }
        self.loadMediaView(staticHeight)
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = kPrimaryColor
        pageControl.currentPageIndicatorTintColor = kPrimaryColor
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        self.contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(topMediaView.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
        }
        
        packageTitle.text = self.viewModel.productDataSource?.name
        packageTitle.font = getFontSize(size: 20, weight: .medium)
        packageTitle.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        packageTitle.numberOfLines = 0
        self.contentView.addSubview(packageTitle)
        packageTitle.snp.makeConstraints { make in
            make.top.equalTo(topMediaView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        
//        discountPercent.text = String(format: "-%.f%%", viewModel.productDataSource?.discountPercent ?? 0.0)
//        discountPercent.backgroundColor = .red
//        discountPercent.textColor = .white
//        discountPercent.font = getFontSize(size: 20, weight: .semibold)
//        self.contentView.addSubview(discountPercent)
//        discountPercent.snp.makeConstraints { make in
//            make.top.equalTo(packageTitle.snp.bottom).offset(5)
//            make.left.equalTo(packageTitle)
//        }
        
        starView.text = "★★★★★"
        starView.font = getFontSize(size: 16, weight: .medium)
        starView.textColor = UIColor.init(hexString: "F1C644")
        contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalTo(packageTitle.snp.bottom).offset(5)
            make.left.equalTo(packageTitle)
        }
        
        priceDiscount.text = String(format: "$%.2f", viewModel.productDataSource?.customFinalPrice ?? 0.0)
        priceDiscount.textColor = kRedHightLightColor
        priceDiscount.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(priceDiscount)
        priceDiscount.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(packageTitle)
        }
        
        priceLabel.text = String(format: "#%.2f", viewModel.productDataSource?.customRegularPrice ?? 0.0)
        priceLabel.textColor = kDisableColor
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.left.equalTo(priceDiscount.snp.right).offset(5)
        }
        
        contentView.addSubview(contentDescView)
        contentDescView.snp.makeConstraints { make in
            make.left.equalTo(packageTitle)
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-50)
        }
        
        self.loadContentDescView()
        
        addToCartBtn.backgroundColor = kPrimaryColor
        addToCartBtn.layer.cornerRadius = 8
        addToCartBtn.titleLabel?.font = getFontSize(size: 16, weight: .medium)
        addToCartBtn.setTitle("Buy Now", for: .normal)
        addToCartBtn.addTarget(self, action: #selector(buyNowButtonTapped), for: .touchUpInside)
        self.view.addSubview(addToCartBtn)
        addToCartBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        
        let touchAction = UITapGestureRecognizer.init(target: self, action: #selector(cartButtonTapped))
        
        cartHotInfo.backgroundColor = kPrimaryColor
        cartHotInfo.addGestureRecognizer(touchAction)
        self.view.addSubview(cartHotInfo)
        cartHotInfo.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(addToCartBtn.snp.top).offset(-10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                self.cartHotInfo.cartPriceValue.text = String(format: "$%.2f", cartDataSource?.customGrandTotal ?? 0.0)
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Buttons
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func cartButtonTapped() {
        let cartVC = CartViewController.sharedInstance
        _NavController.pushViewController(cartVC, animated: true)
    }
    
    @objc private func buyNowButtonTapped() {
        guard let productData = self.viewModel.productDataSource else {return}
        let addProductPopup = AddToCartViewController.init(productData: productData)
        addProductPopup.modalPresentationStyle = .overFullScreen
        self.present(addProductPopup, animated: true, completion: nil)
    }
    
    //MARK: - Data
    private func loadMediaView(_ height: CGFloat) {
        guard let listMedia = viewModel.productDataSource?.media else {return}
        
        for subView in topMediaView.subviews {
            subView.removeFromSuperview()
        }
        
        let width = UIScreen.main.bounds.size.width
        let size = CGSize(width: width, height: height)
        var index = 0
        
        for mediaData in listMedia {
            
            let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
            
            let cell = BannerView.init(frame: frame)
            if let imageURL = URL.init(string: mediaData.value ?? "") {
                cell.bannerImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
            }
            topMediaView.addSubview(cell)
            
            index += 1
        }
        self.pageControl.numberOfPages = listMedia.count
        topMediaView.contentSize = CGSize.init(width: CGFloat(listMedia.count)*(size.width), height: size.height)
    }
    
    private func loadContentDescView() {
        for subview in contentDescView.subviews {
            subview.removeFromSuperview()
        }
        
        guard let productData = self.viewModel.productDataSource else {return}
        
        var lastView: UIView? = nil
        for content in productData.desc {
            let titleLabel = UILabel()
            titleLabel.text = content.title
            titleLabel.textColor = UIColor.init(hexString: "172B4D")
            titleLabel.font = .boldSystemFont(ofSize: 16)
            contentDescView.addSubview(titleLabel)
            
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
            contentLabel.font = .systemFont(ofSize: 16)
            contentDescView.addSubview(contentLabel)
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
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        self.topMediaView.setContentOffset(CGPoint(x: CGFloat(current)*view.frame.width, y: 0), animated: true)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        
        let page = lroundf(Float(fractionalPage))
        self.pageControl.currentPage = page
    }
}
