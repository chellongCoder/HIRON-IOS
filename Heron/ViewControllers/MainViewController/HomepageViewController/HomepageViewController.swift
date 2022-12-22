//
//  HomepageViewController.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import iCarousel

class HomepageViewController: PageScrollViewController,
                              UITableViewDelegate,
                              UIScrollViewDelegate,
                              iCarouselDataSource, iCarouselDelegate,
                              UICollectionViewDataSource,
                              ProductFilterDelegate {
    
    private let viewModel           = HomepageViewModel()
    
    private let bannerScrollView    = iCarousel()
    private let pageControl         = UIPageControl()
    private let categoryView        = UIView()
    private let brandView           = UIView()
    private let featureView         = UIView()
    private let suggestedView       = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        viewModel.controller = self
        
        let logoImage = UIImageView()
        logoImage.image = UIImage.init(named: "logo")
        self.view.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(24)
            make.width.equalTo(107)
        }
        
        let avatarBtn = UIButton()
        avatarBtn.setImage(UIImage.init(named: "avatar_default"), for: .normal)
        avatarBtn.addTarget(self, action: #selector(avatarButtonTapped), for: .touchUpInside)
        self.view.addSubview(avatarBtn)
        avatarBtn.snp.makeConstraints { make in
            make.top.equalTo(logoImage)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(30)
        }
        
        let searchBtn = UIButton()
        searchBtn.setImage(UIImage.init(named: "search_bar_icon"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        self.view.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { make in
            make.top.equalTo(logoImage)
            make.right.equalTo(avatarBtn.snp.left).offset(-10)
            make.height.width.equalTo(30)
        }
        
        self.pageScroll.snp.remakeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        let staticHeight = UIScreen.main.bounds.size.width * 0.96
        
        bannerScrollView.type = .rotary
        bannerScrollView.delegate = self
        bannerScrollView.dataSource = self
        self.pageScroll.addSubview(bannerScrollView)
        bannerScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.left.width.equalToSuperview()
            make.height.equalTo(staticHeight)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.pageScroll.addSubview(refreshControl)
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = kDisableColor
        pageControl.currentPageIndicatorTintColor = kPrimaryColor
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        self.pageScroll.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(bannerScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
        }
        
        self.reloadCategoryView()
        self.reloadBrandView()
        self.reloadFeatureProductView()
        self.reloadSuggestedView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.getProductList()
        self.viewModel.getListCategoris()
    }
    
    // MARK: - Buttons
    
    @objc private func avatarButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature is not available at the moment.",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                             style: .default,
                                             handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
    
    @objc private func searchButtonTapped() {
        let alertVC = UIAlertController.init(title: "Ops!", message: "This feature is not available at the moment.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
    
    @objc private func cartButtonTapped() {
        _NavController.presentCartPage()
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = ProductFilterViewController()
        filterVC.delegate = self
        _NavController.pushViewController(filterVC, animated: true)
    }
    
    override func reloadData() {
        self.viewModel.getProductList()
        self.viewModel.getListCategoris()
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        bannerScrollView.currentItemIndex = current
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        viewModel.listCategories
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.reloadCategoryView()
            }
            .disposed(by: disposeBag)
    }
    
    private func reloadCategoryView() {
        
        for subView in self.categoryView.subviews {
            subView.removeFromSuperview()
        }
        
        if viewModel.listCategories.value.isEmpty {
            self.pageScroll.addSubview(self.categoryView)
            self.categoryView.snp.remakeConstraints { make in
                make.top.equalTo(pageControl.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
        } else {
            self.pageScroll.addSubview(self.categoryView)
            self.categoryView.snp.remakeConstraints { make in
                make.top.equalTo(pageControl.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
            
            let categoryTitle = UILabel()
            categoryTitle.text = "Category"
            categoryTitle.textColor = kDefaultTextColor
            categoryTitle.font = getCustomFont(size: 18, name: .bold)
            self.categoryView.addSubview(categoryTitle)
            categoryTitle.snp.makeConstraints { make in
                make.top.equalTo(pageControl.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(16)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            }
            
            let viewWidth = UIScreen.main.bounds.size.width/3
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
            var fixedHeight = viewWidth // 1 row
            if viewModel.listCategories.value.count >= 6 {
                // 2 rows
                fixedHeight = viewWidth*2
            }
            
            let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionview.dataSource = self
            collectionview.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
            collectionview.showsVerticalScrollIndicator = false
            collectionview.isScrollEnabled = false
            collectionview.backgroundColor = .white
            self.categoryView.addSubview(collectionview)
            collectionview.snp.makeConstraints { make in
                make.top.equalTo(categoryTitle.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(fixedHeight)
                make.bottom.lessThanOrEqualToSuperview().offset(-50)
            }
        }
    }
    
    private func reloadBrandView() {
        for subView in self.brandView.subviews {
            subView.removeFromSuperview()
        }
        
        if viewModel.listBrands.value.isEmpty {
            self.pageScroll.addSubview(self.brandView)
            self.brandView.snp.remakeConstraints { make in
                make.top.equalTo(categoryView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
        } else {
            brandView.backgroundColor = UIColor.init(hexString: "fafafa")
            self.pageScroll.addSubview(self.brandView)
            self.brandView.snp.remakeConstraints { make in
                make.top.equalTo(categoryView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(148)
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
            
            let brandTitle = UILabel()
            brandTitle.text = "Brand"
            brandTitle.textColor = kDefaultTextColor
            brandTitle.font = getCustomFont(size: 18, name: .bold)
            self.brandView.addSubview(brandTitle)
            brandTitle.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(30)
                make.left.equalToSuperview().offset(16)
            }

            let brandScrollView = UIScrollView()
            brandScrollView.showsHorizontalScrollIndicator = false
            self.brandView.addSubview(brandScrollView)
            brandScrollView.snp.makeConstraints { make in
                make.top.equalTo(brandTitle.snp.bottom).offset(20)
                make.height.equalTo(50)
                make.left.right.width.equalToSuperview()
            }
            
            var lastView : UIView?
            for brand in viewModel.listBrands.value {
                let cell = BrandView()
                cell.imageView.image = UIImage.init(named: brand)
                brandScrollView.addSubview(cell)

                if lastView == nil {
                    cell.snp.makeConstraints { make in
                        make.left.top.bottom.height.equalToSuperview()
                        make.width.equalTo(90)
                    }
                } else {
                    cell.snp.makeConstraints { make in
                        make.left.equalTo(lastView!.snp.right).offset(10)
                        make.top.bottom.height.equalToSuperview()
                        make.width.equalTo(90)
                    }
                }

                lastView = cell
            }

            lastView?.snp.makeConstraints({ make in
                make.right.lessThanOrEqualToSuperview()
            })
        }
    }
    
    private func reloadFeatureProductView() {
        for subView in self.featureView.subviews {
            subView.removeFromSuperview()
        }
        self.featureView.backgroundColor = .yellow
        
        if viewModel.listProducts.value.isEmpty {
            self.pageScroll.addSubview(self.featureView)
            self.featureView.snp.remakeConstraints { make in
                make.top.equalTo(brandView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
        } else {
            self.pageScroll.addSubview(self.featureView)
            self.featureView.snp.remakeConstraints { make in
                make.top.equalTo(brandView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(413)
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
        }
    }
    
    private func reloadSuggestedView() {
        for subView in self.suggestedView.subviews {
            subView.removeFromSuperview()
        }
        self.suggestedView.backgroundColor = .systemPink
        
        if viewModel.listProducts.value.isEmpty {
            self.pageScroll.addSubview(self.suggestedView)
            self.suggestedView.snp.remakeConstraints { make in
                make.top.equalTo(featureView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
        } else {
            self.pageScroll.addSubview(self.suggestedView)
            self.suggestedView.snp.remakeConstraints { make in
                make.top.equalTo(featureView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(413)
                make.bottom.lessThanOrEqualToSuperview().offset(-30)
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        
        let page = lroundf(Float(fractionalPage))
        self.pageControl.currentPage = page
    }
    
    // MARK: - ProductFilterDelegate
    func didApplyFilter(_ data: CategoryDataSource?) {
        self.viewModel.filterData = data
    }
    
    // MARK: - iCarouselDataSource
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        self.pageControl.numberOfPages = viewModel.listBanners.count
        return viewModel.listBanners.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let width = UIScreen.main.bounds.size.width * 0.87
        let height = UIScreen.main.bounds.size.width * 0.96
        let size = CGSize(width: width, height: height)
        
        let imageName = viewModel.listBanners[index]
        let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
        
        let cell = BannerView.init(frame: frame)
        cell.bannerImage.image = UIImage.init(named: imageName)
        return cell
    }
    
    func numberOfPlaceholders(in carousel: iCarousel) -> Int {
        return 2
    }
    
    // MARK: - iCarouselDelegate
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.pageControl.currentPage = carousel.currentItemIndex
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.listCategories.value.count < 3 {
            return viewModel.listCategories.value.count
        } else if viewModel.listCategories.value.count < 6 {
            // 1 rows
            return 3
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
        
        var isMoreItems = false
        var moreCount = 0
        if viewModel.listCategories.value.count <= 2 {
            // 2 items
        } else if viewModel.listCategories.value.count == 3 {
            // 3 items
        } else if viewModel.listCategories.value.count <= 5 {
            // 2 items + 1 more
            if indexPath.row == 2 {
                isMoreItems = true
                moreCount = viewModel.listCategories.value.count - 2
            }
        } else if viewModel.listCategories.value.count == 6 {
            // 6 items
        } else {
            // > 6
            // 5 items + 1 more
            if indexPath.row == 5 {
                isMoreItems = true
                moreCount = viewModel.listCategories.value.count - 5
            }
        }
        
        if isMoreItems {
            // setting more cell
            cell?.setMoreData(moreCount)
            cell?.setCategoryUICode(viewModel.getMoreUICode(indexPath.section))
        } else {
            let cellData = viewModel.listCategories.value[indexPath.row]
            cell?.setDataSource(data: cellData)
            cell?.setCategoryUICode(viewModel.getUICodeByIndex(indexPath.row))
        }
        
        return cell!
    }
}
