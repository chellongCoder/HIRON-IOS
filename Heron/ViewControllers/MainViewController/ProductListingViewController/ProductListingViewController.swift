//
//  ProductListingViewController.swift
//  Heron
//
//  Created by Luu Luc on 27/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import BadgeHub

class ProductListingViewController: BaseViewController,
                                    UITableViewDelegate,
                                    ProductFilterDelegate,
                                    ProductCellDelegate {
    
    private let viewModel           = ProductListingViewModel()
    
    let searchBar                   = SearchBarTxt()
    let tableView                   = UITableView(frame: .zero, style: .plain)
    let noDataView                  = UIView()
    var cartHub                     : BadgeHub?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        viewModel.controller = self
        
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
        
        let cartButton = UIButton()
        cartButton.setBackgroundImage(UIImage.init(named: "cart_bar_icon"), for: .normal)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        self.cartHub = BadgeHub(view: cartButton)
        self.cartHub?.setCircleAtFrame(CGRect(x: 12, y: -10, width: 20, height: 20))
        self.cartHub?.setCircleColor(kRedHightLightColor, label: .white)
        self.cartHub?.setCircleBorderColor(.white, borderWidth: 1)
        self.cartHub?.setMaxCount(to: 99)
        self.cartHub?.setCount(0)
        self.cartHub?.pop()
        
        let cartButtonItem = UIBarButtonItem(customView: cartButton)
        let changeViewStyleItem = UIBarButtonItem.init(image: UIImage.init(named: "collection_bar_icon"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(filterButtonTapped))
        self.navigationItem.rightBarButtonItems = [cartButtonItem, changeViewStyleItem]
        
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
        
        noDataView.isHidden = true
        self.tableView.addSubview(noDataView)
        noDataView.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
        }
        
        let noDataLabel = UILabel()
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0
        noDataLabel.font = getCustomFont(size: 16, name: .regular)
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
    
    // MARK: - Binding Data
    override func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                self.cartHub?.setCount(cartDataSource?.totalItemCount ?? 0)
                self.cartHub?.pop()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = viewModel.listProducts.value
        let productData = value[indexPath.row]
        
//        let viewDetailsController = ProductDetailsViewController.init(productData)
        let viewDetailsController = ProductDetailsViewController2.init(productData)
        _NavController.pushViewController(viewDetailsController, animated: true)
        
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
