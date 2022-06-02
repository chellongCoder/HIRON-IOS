//
//  CartViewController.swift
//  Heron
//
//  Created by Luu Luc on 10/05/2022.
//

import UIKit
import RxSwift

class CartViewController: BaseViewController,
                          UITableViewDataSource, UITableViewDelegate,
                          CartProductCellDelegate {
    
    public static let sharedInstance    = CartViewController()
    private let viewModel               = CartViewModel()
    let tableView                       = UITableView(frame: .zero, style: .grouped)
    
    private let totalLabel              = UILabel()
    private let savingLabel             = UILabel()
    private let checkoutBtn             = UIButton()
    
    private let disposeBag              = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Cart"
        self.viewModel.controller = self
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
//        let checkoutBtn = UIBarButtonItem.init(title: "Checkout",
//                                               style: .plain,
//                                               target: self,
//                                               action: #selector(checkoutButtonTapped))
//        self.navigationItem.rightBarButtonItem = checkoutBtn

        savingLabel.text = "Saving: $0"
        savingLabel.textColor = kDefaultTextColor
        savingLabel.font = .systemFont(ofSize: 16)
        self.view.addSubview(savingLabel)
        savingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        totalLabel.text = "Total: $0"
        totalLabel.textColor = kDefaultTextColor
        totalLabel.font = .systemFont(ofSize: 20)
        totalLabel.adjustsFontSizeToFitWidth = false
        totalLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.bottom.equalTo(savingLabel.snp.top).offset(-5)
            make.left.equalToSuperview().offset(20)
        }
        
        checkoutBtn.backgroundColor = kPrimaryColor
        checkoutBtn.setTitleColor(.white, for: .normal)
        checkoutBtn.setTitle("Checkout", for: .normal)
        checkoutBtn.layer.cornerRadius = 8
        checkoutBtn.setContentHuggingPriority(.defaultLow, for: .horizontal)
        checkoutBtn.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        self.view.addSubview(checkoutBtn)
        checkoutBtn.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.top)
            make.bottom.equalTo(savingLabel.snp.bottom)
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(totalLabel.snp.right).offset(15)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(CartProductTableViewCell.self, forCellReuseIdentifier: "CartProductTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(totalLabel.snp.top).offset(-10)
        }
        
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.reloadCart()
    }
    
    //MARK: - BindingData
    private func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                
                guard let cartData = cartDataSource.element as? CartDataSource else {return}
                self.viewModel.cartDataSource = cartData
                
                self.totalLabel.text = String(format: "Total: $%ld", cartData.grandTotal)
                self.savingLabel.text = String(format: "Saving: $%ld", (cartData.subtotal - cartData.grandTotal))
                
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Buttons
    @objc private func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func checkoutButtonTapped() {
        //Handle checkout
        viewModel.checkout()
    }
    
    //MARK: - Cart
    func addProductToCart(_ data: ProductDataSource) {
        viewModel.addToCart(product: data)
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cartDataSource?.store.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartDataSource?.store[section].cartItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductTableViewCell") as! CartProductTableViewCell
        let storeData = viewModel.cartDataSource?.store[indexPath.section]
        if let cellData = storeData?.cartItems[indexPath.row] {
            cell.setDataSource(cellData, indexPath: indexPath)
            if cellData.product!.discountPercent > 0 {
                cell.discountPercent.text = String(format: "-%.f%%", cellData.product!.discountPercent )
            } else {
                cell.discountPercent.isHidden = true
            }
        }
        
        cell.delegate = self
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        if let storeData = _CartServices.cartData.value?.store[section] {
            let titleSignal = UILabel()
            titleSignal.text = storeData.storeDetails?.name ?? ""
            headerView.addSubview(titleSignal)
            titleSignal.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.height.equalTo(30)
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - CartProductCellDelegate
    func removeItemFromCart(_ index: IndexPath) {
        guard let store = _CartServices.cartData.value?.store[index.section] else {return}
        let cartItem = store.cartItems[index.row]
        viewModel.removeItemFromCart(cartItem)
    }
    
    func modifyCheckoutList(_ index: IndexPath) {
        guard let store = _CartServices.cartData.value?.store[index.section] else {return}
        let isSelected = store.cartItems[index.row].isSelected
        
        var cartData = _CartServices.cartData.value
        cartData?.store[index.section].cartItems[index.row].isSelected = !isSelected
        
        _CartServices.cartData.accept(cartData)
        self.tableView.reloadData()
    }
}
