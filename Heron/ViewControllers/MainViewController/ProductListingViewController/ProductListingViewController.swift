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
                                    ProductFilterDelegate {
    
    private let viewModel           = ProductListingViewModel()
    
    let searchBar                   = SearchBarTxt()
    let filterView                  = ProductListingFilterView()
    let tableView                   = UITableView(frame: .zero, style: .plain)
    var collectionView              : UICollectionView?
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
        let changeViewStyleItem = UIBarButtonItem.init(image: UIImage.init(named: "list_bar_icon"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(switchViewButtonTapped))
        self.navigationItem.rightBarButtonItems = [cartButtonItem, changeViewStyleItem]
        
        self.view.addSubview(filterView)
        filterView.snp.makeConstraints { make in
            make.top.centerX.width.equalToSuperview()
            make.height.equalTo(80)
        }
        
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
            make.top.equalTo(filterView.snp.bottom)
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let screenSize = UIScreen.main.bounds
        let layout = UICollectionViewFlowLayout()
        let cellWidth = screenSize.width/2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 97)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        collectionView?.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.equalTo(filterView.snp.bottom)
            make.left.right.centerX.width.equalToSuperview()
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
    
    @objc private func switchViewButtonTapped(_ sender: UIBarButtonItem) {
        let viewMode = viewModel.viewMode.value
        
        switch viewMode {
        case .gridView:
            viewModel.viewMode.accept(.listView)
            sender.image = UIImage.init(named: "collection_bar_icon")
        case .listView:
            viewModel.viewMode.accept(.gridView)
            sender.image = UIImage.init(named: "list_bar_icon")
        }
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
                
                guard let cartData = cartDataSource.element else {return}
                
                self.cartHub?.setCount(cartData?.totalItemCount ?? 0)
                self.cartHub?.pop()
            }
            .disposed(by: disposeBag)
        
        viewModel.viewMode
            .observe(on: MainScheduler.instance)
            .subscribe { viewMode in
                switch viewMode.element ?? .listView {
                case .gridView:
                    self.tableView.isHidden = true
                    self.collectionView?.isHidden = false
                case .listView:
                    self.tableView.isHidden = false
                    self.collectionView?.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.listProducts
            .bind(to: tableView.rx.items) { (_: UITableView, _: Int, element: ProductDataSource) in
                let cell = ProductTableViewCell(style: .default, reuseIdentifier:"ProductTableViewCell")
                cell.setDataSource(element)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.listProducts
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.collectionView?.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = viewModel.listProducts.value
        let productData = value[indexPath.row]
        
        let viewDetailsController = ProductDetailsViewController.init(productData)
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

extension ProductListingViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = viewModel.listProducts.value
        let productData = value[indexPath.row]
        
        let viewDetailsController = ProductDetailsViewController.init(productData)
        _NavController.pushViewController(viewDetailsController, animated: true)
        
        self.dismissKeyboard()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listProducts.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        let value = viewModel.listProducts.value
        let productData = value[indexPath.row]
        cell.setDataSource(productData)
        return cell
    }
}
