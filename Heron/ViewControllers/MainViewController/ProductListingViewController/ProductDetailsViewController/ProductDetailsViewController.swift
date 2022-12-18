//
//  ProductDetailsViewController.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit
import RxSwift
import BadgeHub

class ProductDetailsViewController: PageScrollViewController,
                                    UIScrollViewDelegate,
                                    UITableViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate {

    private let viewModel               = ProductDetailsViewModel()
    private let productViewModel        = ProductListingViewModel()

    private let topMediaView            = UIScrollView()
    private let pageControl             = UIPageControl()
    
    var cartButtonItem                  : UIBarButtonItem?
    var shareButtonItem                 : UIBarButtonItem?
    var moreButtonItem                  : UIBarButtonItem?
    var cartHub                         : BadgeHub?
    var collectionview                  : UICollectionView!
    var footer                          : ProductDetailFooter!
    var simpleProductData               : ProductDataSource?

    var showTabView                     = false
    var topMediaViewHeight              = CGFloat(0)
    var mediaCount                      = 0

    private let bannerImage             = UIImageView()
    private let tabView                 = TabViewProductDetail()
    private let pagingView              = UILabel()
    private let topView                 = UIImageView()
    private let contentDescView         = UIView()
    let heartItem                       = UIButton(type: .custom)
    private let nameProduct             = UILabel()

    let showMoreView                    = UIView()
    let stackTagView                    = StackTagView()
    let stackInfoView                   = StackInfoView()
    let descView                        = UIView()
    let shopView                        = ShopProductView()
    let reviewRate                      = ReviewRate()
    let tableRateView                   = UITableView(frame: .zero, style: .plain)

    private let packageTitle            = UILabel()
    private let tagsViewStack           = UIStackView()
    private let priceDiscount           = UILabel()
    private let priceLabel              = DiscountLabel()
    private let starView                = UILabel()
    private let variantView             = ConfigurationProductVariantView()
    private let cartHotInfo             = CartHotView()

    init(_ data: ProductDataSource) {
        super.init(nibName: nil, bundle: nil)
        viewModel.productDataSource.accept(data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Buttons
    @objc private func filterButtonTapped() {
        _NavController.presentCartPage()
    }
    
    @objc private func shareButtonTapped() {
        //Set the default sharing message.
        let message = "Message goes here."
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackBtn()
        self.viewModel.controller = self
        
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
        
        self.footer = ProductDetailFooter(frame: .zero, disposeBag)
        self.view.addSubview(footer)
        footer.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        self.footer.controller = self
        self.footer.viewModel = viewModel
        self.footer.disposeBag = disposeBag

        cartButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_bar_icon"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(cartButtonTapped))
        cartButtonItem?.tintColor = kDefaultTextColor
        self.cartHub = BadgeHub(barButtonItem: cartButtonItem!)
        self.cartHub?.setCircleColor(kRedHightLightColor, label: .white)
        self.cartHub?.setCircleBorderColor(.white, borderWidth: 1)
        self.cartHub?.setMaxCount(to: 99)
        self.cartHub?.setCount(10)
        self.cartHub?.pop()
        
        shareButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "shareIcon"),
                                                   style: .done,
                                              target: self,
                                              action: #selector(shareButtonTapped))
        shareButtonItem?.tintColor = kDefaultTextColor
        
        moreButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "moreIcon"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(filterButtonTapped))
        moreButtonItem?.tintColor = kDefaultTextColor

        self.navigationItem.rightBarButtonItems = [moreButtonItem!, shareButtonItem!, cartButtonItem!]
                
        pageScroll.delegate = self
        pageScroll.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(footer.snp.top).offset(-10)
        }

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        pageScroll.addSubview(refreshControl)
        
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
        
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        
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

        contentDescView.addSubview(stackTagView)
        stackTagView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(30)
        }

        heartItem.setImage(UIImage(systemName: "heart"), for: .normal)
        heartItem.tintColor = kDefaultTextColor
        contentDescView.addSubview(heartItem)
        heartItem.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

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
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        contentDescView.addSubview(stackInfoView)
        stackInfoView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(contentDescView)
        contentDescView.snp.makeConstraints { (make) in
            make.top.equalTo(topMediaView.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(contentDescView.snp.width).multipliedBy(0.3)
        }

        self.variantView.delegate = self
        self.contentView.addSubview(variantView)
        variantView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(contentDescView.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
        }
        
        let spacer = SpacerView()
        self.contentView.addSubview(spacer)
        spacer.snp.makeConstraints { (make) in
            make.top.equalTo(variantView.snp.bottom).offset(0)
            make.height.equalTo(6)
            make.width.equalToSuperview()
        }

        self.contentView.addSubview(shopView)
        shopView.snp.makeConstraints { (make) in
            make.top.equalTo(spacer.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }

        let spacer2 = SpacerView()
        self.contentView.addSubview(spacer2)
        spacer2.snp.makeConstraints { (make) in
            make.top.equalTo(shopView.snp.bottom).offset(10)
            make.height.equalTo(6)
            make.width.equalToSuperview()
        }

        contentView.addSubview(descView)
        descView.snp.makeConstraints { make in
            make.left.right.equalTo(10)
            make.top.equalTo(spacer2.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
            make.width.equalToSuperview().offset(-20)
        }

        let showMoreTxt = UILabel()
       
        showMoreTxt.text = "Show more"
        showMoreTxt.font = getCustomFont(size: 11, name: .regular)
        showMoreView.addSubview(showMoreTxt)
        showMoreTxt.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        self.contentView.addSubview(showMoreView)
        showMoreView.snp.makeConstraints { make in
            make.top.equalTo(descView.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        let dropdown = UIImageView()
        dropdown.clipsToBounds = true
        dropdown.image = UIImage(named: "dropdown")?.withRenderingMode(.alwaysOriginal)
        dropdown.contentMode = .scaleAspectFit

        showMoreView.addSubview(dropdown)
        dropdown.snp.makeConstraints { make in
            make.left.equalTo(showMoreTxt.snp.right).offset(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10)
        }
        
        self.loadReviewView()
        
        self.loadRelateProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        viewModel.reloadProductDetails()
    }
    
    // MARK: - Binding Data
    override func reloadData() {
        viewModel.reloadProductDetails()
    }
    
    override func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                self.cartHotInfo.cartPriceValue.text = getMoneyFormat(cartDataSource?.customGrandTotal)
            }
            .disposed(by: disposeBag)
        productViewModel.listProducts
            .bind(to: tableRateView.rx.items) { (_: UITableView, _: Int, element: ProductDataSource) in
                let cell = ItemReviewTableViewCell(style: .default, reuseIdentifier:"ItemReviewTableViewCell")
                return cell
            }
            .disposed(by: disposeBag)

        viewModel.productDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { productDataSource in
                guard let productDataA = productDataSource.element else {return}
                guard let productData = productDataA else {return}
                
                self.nameProduct.text = productData.name
                self.stackInfoView.setDiscountPercent(String(format:"%.1f", productData.discountPercent) + "%")
                self.stackInfoView.setOriginalPrice(getMoneyFormat(productData.customRegularPrice))
                self.stackInfoView.setSalePrice(getMoneyFormat(Float(productData.customFinalPrice)))
                self.stackInfoView.setSaleAmount("\(productData.quantity)")
                self.stackInfoView.setStars("★★★★★")
                self.stackInfoView.setReviewView("4")
                
                if productData.media.count > 1 {
                    self.pagingView.text = "1/\(productData.media.count)"
                    self.mediaCount = productData.media.count
                } else {
                    self.pagingView.alpha = 0
                }
                
                self.shopView.shopName.text = productData.brand?.name
                self.shopView.shopDesc.text = ""
                self.variantView.setConfigurationProduct(productData, isAllowToChange: true)
                self.loadContentDescView()
                self.loadTagsContents()
                let staticHeight = (UIScreen.main.bounds.size.width)
                self.loadMediaView(staticHeight)

            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Buttons
    @objc private func cartButtonTapped() {
        _NavController.presentCartPage()
    }
 
    // MARK: - Data
    private func loadMediaView(_ height: CGFloat) {
        guard let listMedia = viewModel.productDataSource.value?.media else {return}
        
        for subView in topMediaView.subviews {
            subView.removeFromSuperview()
        }
        
        let width = UIScreen.main.bounds.size.width
        let size = CGSize(width: width, height: height)
        var index = 0
        
        for mediaData in listMedia {
            
            let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
            
            let cell = ProductBannerView.init(frame: frame)
            if let imageURL = URL.init(string: mediaData.value ?? "") {
                cell.bannerImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
            }
            topMediaView.addSubview(cell)
            
            index += 1
        }
        
        let mediaData = listMedia[0]
        if let imageURL = URL.init(string: mediaData.value ?? "") {
            topView.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
        }

        self.pageControl.numberOfPages = listMedia.count
        topMediaView.contentSize = CGSize.init(width: CGFloat(listMedia.count)*(size.width), height: size.height)
    }
    
    private func loadTagsContents() {
        for arrangedSubview in stackTagView.stack.stackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
        
        guard let productDataSource = self.viewModel.productDataSource.value else {return}

        switch productDataSource.featureType {
        case .ecom:
            let newChipView = TagView.init(title: "Physical Product")
            stackTagView.addArrangedSubview(newChipView)
        case .ecom_booking:
            let newChipView = TagView.init(title: "Virtual Product")
            stackTagView.addArrangedSubview(newChipView)
        }
        
        if let unitName = productDataSource.unit?.name {
            let newChipView = TagView.init(title: unitName)
            stackTagView.addArrangedSubview(newChipView)
        }
        
        if let brandName = productDataSource.brand?.name {
            let newChipView = TagView.init(title: brandName)
            stackTagView.addArrangedSubview(newChipView)
        }
        
    }
    
    private func loadContentDescView() {
        for subview in descView.subviews {
            subview.removeFromSuperview()
        }

        guard let productDataSource = self.viewModel.productDataSource.value else {return}
       
        var lastView                        : UIView?

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
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            paragraphStyle.minimumLineHeight = 10
            let attrString = content.content.htmlAttributedString()
            attrString?.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString!.length))

            let contentLabel = UILabel()
            contentLabel.numberOfLines = 0
            
            contentLabel.attributedText = attrString
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
    
    private func loadReviewView() {
        let spacer3 = SpacerView()
        self.contentView.addSubview(spacer3)
        spacer3.snp.makeConstraints { (make) in
            make.top.equalTo(self.showMoreView.snp.bottom).offset(20)
            make.height.equalTo(6)
            make.width.equalToSuperview()
        }
        
        tableRateView.delegate = self
        tableRateView.separatorStyle = .none
        tableRateView.isScrollEnabled = false
        tableRateView.register(ItemReviewTableViewCell.self, forCellReuseIdentifier: "ItemReviewTableViewCell")
        self.contentView.addSubview(tableRateView)
        tableRateView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(spacer3.snp.bottom).offset(10)
            make.height.equalTo(500)
            make.width.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)

        }
        
        let showMoreTxt = UILabel()
        let showMoreView = UIView()
        
        showMoreTxt.text = "Show all"
        showMoreTxt.font = getCustomFont(size: 11, name: .regular)
        showMoreView.addSubview(showMoreTxt)
        showMoreTxt.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        self.contentView.addSubview(showMoreView)
        showMoreView.snp.makeConstraints { make in
            make.top.equalTo(tableRateView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        let dropdown = UIImageView()
        dropdown.clipsToBounds = true
        dropdown.image = UIImage(named: "arrowright")?.withRenderingMode(.alwaysOriginal)
        dropdown.contentMode = .scaleAspectFit

        showMoreView.addSubview(dropdown)
        dropdown.snp.makeConstraints { make in
            make.left.equalTo(showMoreTxt.snp.right).offset(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10)
        }

    }
    
    private func loadRelateProducts() {
        let spacer3 = SpacerView()
        self.contentView.addSubview(spacer3)
        spacer3.snp.makeConstraints { (make) in
            make.top.equalTo(tableRateView.snp.bottom).offset(30)
            make.height.equalTo(6)
            make.width.equalToSuperview()
        }
        
        let title = UILabel()
        title.text = "Related product"
        title.font = getCustomFont(size: 18, name: .bold)
        self.contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(spacer3.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }

        let viewWidth = UIScreen.main.bounds.size.width/2.2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: viewWidth, height: viewWidth * 1.5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(ItemRelateProductCollection.self, forCellWithReuseIdentifier: "ItemRelateProductCollection")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.isScrollEnabled = false
        self.contentView.addSubview(collectionview)
        collectionview.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(10)
            make.height.equalTo(500)
            make.width.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

    }

    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        self.topMediaView.setContentOffset(CGPoint(x: CGFloat(current)*view.frame.width, y: 0), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == self.topMediaView) {
            let pageWidth = scrollView.frame.size.width
            let fractionalPage = scrollView.contentOffset.x / pageWidth

            let page = lroundf(Float(fractionalPage))
            self.pageControl.currentPage = page
            pagingView.text = "\(page+1)/\(self.mediaCount)"

            guard let listMedia = viewModel.productDataSource.value?.media else {return}
            let mediaData = listMedia[page]
            if let imageURL = URL.init(string: mediaData.value ?? "") {
                topView.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
            }

        } else if(scrollView == self.pageScroll) {
            if (self.topMediaView.frame.size.height > 0) {
                self.topMediaViewHeight = self.topMediaView.frame.size.height
            }
            let contentOffset = scrollView.contentOffset
            if (contentOffset.y >= self.topMediaViewHeight * 0.2) {
                let alpha = min(1, 2 * contentOffset.y / self.topMediaViewHeight - 1)
                self.topMediaView.alpha = 1 - alpha
                print(self.topMediaViewHeight)
                if (!self.showTabView && contentOffset.y >= self.topMediaViewHeight * 0.8) {
                    DispatchQueue.main.async {
                        self.navigationItem.titleView = self.topView
                        self.topView.alpha = (5 * contentOffset.y / self.topMediaViewHeight) - 4
                    }
                }
                if (!self.showTabView && contentOffset.y >= self.topMediaViewHeight) {
                    DispatchQueue.main.async {
                        self.pagingView.alpha = 0
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
                        self.showTabView = true
                    }
                }
            }
            if (self.showTabView && contentOffset.y < self.topMediaViewHeight) {
                let staticHeight = (UIScreen.main.bounds.size.width) * 1
                let alpha = min(1, 2 * contentOffset.y / self.topMediaViewHeight - 1)
                DispatchQueue.main.async {
                    self.navigationItem.titleView = nil
                    self.topMediaView.snp.remakeConstraints { make in
                        make.top.equalToSuperview()
                        make.right.left.equalToSuperview()
                        make.bottom.equalTo(self.topMediaView.snp.top).offset(staticHeight)
                    }
                    self.topMediaView.alpha = 1 - alpha
                }
            }
            if (self.showTabView && contentOffset.y < self.topMediaViewHeight * 0.8) {
                DispatchQueue.main.async {
                    self.pagingView.alpha = 0.3
                    self.tabView.snp.remakeConstraints({ make in
                        make.left.equalToSuperview().offset(0)
                        make.top.equalToSuperview()
                        make.width.equalToSuperview()
                        make.height.equalTo(0)
                    })
                }
                
                self.showTabView = false
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
        // (UIScreen.main.bounds.size.width - 32)*1.2 + (10+15+10)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 
        reviewRate.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(UIScreen.main.bounds.size.width)
        }
        return self.reviewRate
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productViewModel.listProducts.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "ItemRelateProductCollection", for: indexPath) as? ItemRelateProductCollection
        return cell!
    }
    
}

extension ProductDetailsViewController : ProductVariantDelegate {
    func didSelectVariant(variants: [SelectedVariant]) {
        guard let listChilren : [ProductDataSource] = self.viewModel.productDataSource.value?.children else {return}
        
        if let matchedSimpleProduct = listChilren.first(where: { simpleProduct in
            return simpleProduct.isMatchingWithVariants(variants)
        }) {
            // Load new UI
            self.nameProduct.text = matchedSimpleProduct.name
            self.stackInfoView.setDiscountPercent(String(format:"%.1f", matchedSimpleProduct.discountPercent) + "%")
            self.stackInfoView.setSalePrice(getMoneyFormat(matchedSimpleProduct.customFinalPrice))
            self.stackInfoView.setOriginalPrice(getMoneyFormat(matchedSimpleProduct.customRegularPrice))
            self.stackInfoView.setSaleAmount("\(matchedSimpleProduct.quantity)")
            let staticHeight = (UIScreen.main.bounds.size.width)*1
            self.loadMediaView(staticHeight)
            
            self.simpleProductData = matchedSimpleProduct

        }
    }
}
