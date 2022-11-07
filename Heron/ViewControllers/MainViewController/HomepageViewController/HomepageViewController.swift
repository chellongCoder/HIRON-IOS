//
//  HomepageViewController.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class HomepageViewController: BaseViewController,
                              UITableViewDelegate,
                              UIScrollViewDelegate,
                              ProductFilterDelegate,
                              ProductCellDelegate {
    
    private let viewModel           = HomepageViewModel()
    
    let searchBar                   = UISearchBar()
    private let bannerScrollView    = UIScrollView()
    private let pageControl         = UIPageControl()
    let tableView                   = UITableView(frame: .zero, style: .grouped)
    let cartHotInfo                 = CartHotView()
    let noDataView                  = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        viewModel.controller = self
        
        searchBar.placeholder = "Seach"
        self.navigationItem.titleView = searchBar
        
//        let cartButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "cart"),
//                                              style: .plain,
//                                              target: self,
//                                              action: #selector(cartButtonTapped))
        
        let filterButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "slider.horizontal.3"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(filterButtonTapped))
        self.navigationItem.rightBarButtonItems = [filterButtonItem]// [filterButtonItem, cartButtonItem]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let touchAction = UITapGestureRecognizer.init(target: self, action: #selector(cartButtonTapped))
        
        cartHotInfo.backgroundColor = kPrimaryColor
        cartHotInfo.addGestureRecognizer(touchAction)
        self.view.addSubview(cartHotInfo)
        cartHotInfo.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        noDataView.isHidden = true
        self.tableView.addSubview(noDataView)
        noDataView.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
        }
        
        let noDataLabel = UILabel()
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0
        noDataLabel.font = getFontSize(size: 16, weight: .regular)
        noDataLabel.text = "No any data to display"
        noDataView.addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(80)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.getProductList()
    }
    
    // MARK: - Buttons
    @objc private func cartButtonTapped() {
        _NavController.presentCartPage()
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = ProductFilterViewController()
        filterVC.delegate = self
        _NavController.pushViewController(filterVC, animated: true)
    }
    
    private func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
    
    override func reloadData() {
        self.viewModel.getProductList()
    }
    
    // MARK: - UI
    private func reloadBannerView() {
        // remove all subviews
        for subView in bannerScrollView.subviews {
            subView.removeFromSuperview()
        }
        
        let width = UIScreen.main.bounds.size.width
        let height = (width-32)*1.2
        let size = CGSize(width: width, height: height)
        var index = 0
        
        for imageName in viewModel.listBanners {
            
            let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
            let cell = BannerView.init(frame: frame)
            cell.bannerImage.image = UIImage.init(named: imageName)
            bannerScrollView.addSubview(cell)
            
            index += 1
        }
        self.pageControl.numberOfPages = viewModel.listBanners.count
        bannerScrollView.contentSize = CGSize.init(width: CGFloat(viewModel.listBanners.count)*(size.width), height: size.height)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        bannerScrollView.setContentOffset(CGPoint(x: CGFloat(current)*view.frame.width, y: 0), animated: true)
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                self.cartHotInfo.cartPriceValue.text = getMoneyFormat(cartDataSource?.customGrandTotal)
            }
            .disposed(by: disposeBag)
        
        viewModel.listProducts
            .bind(to: tableView.rx.items) { (_: UITableView, _: Int, element: ProductDataSource) in
                let cell = ProductTableViewCell(style: .default, reuseIdentifier:"ProductTableViewCell")
                cell.setDataSource(element)
                cell.delegate = self
                return cell
            }
            .disposed(by: disposeBag)
        
//        tableView.rx
//            .modelSelected(ProductDataSource.self)
//            .subscribe { model in
//                guard let productData = model.element else {return}
//                let viewDetailsController = ProductDetailsViewController.init(productData)
//                _NavController.pushViewController(viewDetailsController, animated: true)
//
//                self.dismissKeyboard()
//            }
//            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
        // (UIScreen.main.bounds.size.width - 32)*1.2 + (10+15+10)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = kBackgroundColor
        
        let staticHeight = (UIScreen.main.bounds.size.width - 32)*1.2
        
        bannerScrollView.isPagingEnabled = true
        bannerScrollView.delegate = self
        bannerScrollView.showsHorizontalScrollIndicator = false
        headerView.addSubview(bannerScrollView)
        bannerScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview()
            make.height.equalTo(staticHeight)
        }
        self.reloadBannerView()
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = kDisableColor
        pageControl.currentPageIndicatorTintColor = kPrimaryColor
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        headerView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(bannerScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = viewModel.listProducts.value
        let productData = value[indexPath.row]
        
        let viewDetailsController = ProductDetailsViewController.init(productData)
        _NavController.pushViewController(viewDetailsController, animated: true)
        
        self.dismissKeyboard()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        
        let page = lroundf(Float(fractionalPage))
        self.pageControl.currentPage = page
        
        self.dismissKeyboard()
    }
    
    // MARK: - ProductFilterDelegate
    func didApplyFilter(_ data: CategoryDataSource?) {
        self.viewModel.filterData = data
    }
    
    // MARK: - ProductCellDelegate
    func addProductToCart(_ data: ProductDataSource) {
        let cartVC = CartViewController.sharedInstance
        cartVC.addProductToCart(data)
    }
}
