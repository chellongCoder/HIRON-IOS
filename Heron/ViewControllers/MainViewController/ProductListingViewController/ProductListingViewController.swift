//
//  ProductListingViewController.swift
//  Heron
//
//  Created by Luu Luc on 27/04/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ProductListingViewController: BaseViewController,
                                    UITableViewDelegate,
                                    UIScrollViewDelegate,
                                    ProductFilterDelegate,
                                    ProductCellDelegate {
    
    private let viewModel           = ProductListingViewModel()
    
    let searchBar                   = UISearchBar()
    private let bannerScrollView    = UIScrollView()
    private let pageControl         = UIPageControl()
    let tableView                   = UITableView(frame: .zero, style: .grouped)
    let cartHotInfo                 = CartHotView()
    let noDataView                  = UIView()
    
    private let disposeBag          = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Products"
        
        viewModel.controller = self
        
        searchBar.placeholder = "Seach"
        self.navigationItem.titleView = searchBar
        
        let cartButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "cart"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(cartButtonTapped))
        
        let filterButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "slider.horizontal.3"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(filterButtonTapped))
        self.navigationItem.rightBarButtonItems = [filterButtonItem, cartButtonItem]
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-90)
        }
        
        cartHotInfo.backgroundColor = kPrimaryColor
        cartHotInfo.layer.cornerRadius = 25
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
        
        self.bindingData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.viewModel.getProductList()
        self.viewModel.reloadCart()
    }
    
    //MARK: - Buttons
    @objc private func cartButtonTapped() {
        let cartVC = CartViewController.sharedInstance
        _NavController.pushViewController(cartVC, animated: true)
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = ProductFilterViewController()
        filterVC.delegate = self
        _NavController.pushViewController(filterVC, animated: true)
    }
    
    private func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
    
    //MARK: - UI
    private func reloadBannerView() {
        // remove all subviews
        for subView in bannerScrollView.subviews {
            subView.removeFromSuperview()
        }
        
        let width = UIScreen.main.bounds.size.width
        let height = (width-32)*0.5625
        let size = CGSize(width: width, height: height)
        var index = 0
        
        for bannerData in viewModel.listBanners {
            
            let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
            
            let cell = BannerView.init(frame: frame)
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
    
    //MARK: - Binding Data
    private func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                self.cartHotInfo.cartPriceValue.text = String(format: "$%ld", cartDataSource?.subtotal ?? 0)
            }
            .disposed(by: disposeBag)
        
        viewModel.listProducts
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: ProductDataSource) in
                let cell = ProductTableViewCell(style: .default, reuseIdentifier:"ProductTableViewCell")
                cell.setDataSource(element)
                cell.delegate = self
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(ProductDataSource.self)
            .subscribe { model in
                guard let productData = model.element else {return}
                let viewDetailsController = ProductDetailsViewController.init(productData)
                _NavController.pushViewController(viewDetailsController, animated: true)
                
                self.dismissKeyboard()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (16 + (UIScreen.main.bounds.size.width - 32)*0.5625 + (10+15+10))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = kBackgroundColor
        
        let staticHeight = (UIScreen.main.bounds.size.width - 32)*0.5625
        
        bannerScrollView.isPagingEnabled = true
        bannerScrollView.delegate = self
        bannerScrollView.showsHorizontalScrollIndicator = false
        headerView.addSubview(bannerScrollView)
        bannerScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.right.left.equalToSuperview()
            make.height.equalTo(staticHeight)
        }
        self.reloadBannerView()
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = kPrimaryColor
        pageControl.currentPageIndicatorTintColor = kPrimaryColor
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        headerView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(bannerScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
        }
        return headerView
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        
        let page = lroundf(Float(fractionalPage))
        self.pageControl.currentPage = page
        
        self.dismissKeyboard()
    }
    
    //MARK: - ProductFilterDelegate
    func didApplyFilter(_ data: CategoryDataSource?) {
        self.viewModel.filterData = data
    }
    
    //MARK: - ProductCellDelegate
    func addProductToCart(_ data: ProductDataSource) {
        let cartVC = CartViewController.sharedInstance
        cartVC.addProductToCart(data)
    }
}
