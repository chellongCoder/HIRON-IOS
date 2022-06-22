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
    
    private let voucherView             = VoucherSelectedView()
    private let totalLabel              = UILabel()
    private let savingLabel             = UILabel()
    private let checkoutBtn             = UIButton()

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
        
        savingLabel.text = "Saving: $0.0"
        savingLabel.textColor = kDefaultTextColor
        savingLabel.font = .systemFont(ofSize: 16)
        self.view.addSubview(savingLabel)
        savingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        totalLabel.text = "Total: $0.0"
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
        
        let voucherTouch = UITapGestureRecognizer.init(target: self, action: #selector(voucherTapped))
        voucherView.addGestureRecognizer(voucherTouch)
        self.view.addSubview(voucherView)
        voucherView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(checkoutBtn.snp.top).offset(-10)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(CartProductTableViewCell.self, forCellReuseIdentifier: "CartProductTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(voucherView.snp.top).offset(-10)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.reloadCart()
    }
    
    //MARK: - BindingData
    override func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                
                guard let cartData = cartDataSource.element as? CartDataSource else {return}
                self.viewModel.cartDataSource = cartData
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        _CartServices.voucherCode
            .observe(on: MainScheduler.instance)
            .subscribe { voucherDataSource in
                guard let voucherDataSource = voucherDataSource.element as? VoucherDataSource else {return}
                if voucherDataSource.couponRule?.isFixed ?? false {
                    // discount value
                    self.voucherView.voucherCode.text = String(format: "$%.2f", voucherDataSource.couponRule?.customDiscount ?? 0.0)
                    
                } else {
                    //discout percent
                    self.voucherView.voucherCode.text = String(format: "%ld%% OFF", voucherDataSource.couponRule?.discount ?? 0)
                }
            }
            .disposed(by: disposeBag)
        
        _CartServices.cartPreCheckoutResponseData
            .observe(on: MainScheduler.instance)
            .subscribe { cartPreCheckoutDataSource in
                guard let cartPreCheckoutDataSource = cartPreCheckoutDataSource.element as? CartPrepearedResponseDataSource else {
                    self.totalLabel.text = "Total: $0.0"
                    self.savingLabel.text = "Saving: $0.0"
                    return
                }
                
                self.totalLabel.text = String(format: "Total: $%.2f", cartPreCheckoutDataSource.checkoutPriceData?.customTotalPayable ?? 0.0)
                self.savingLabel.text = String(format: "Saving: $%.2f", cartPreCheckoutDataSource.checkoutPriceData?.customCouponApplied ?? 0.0)
                
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Buttons
    @objc private func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func storeCheckboxButtonTapped(button: UIButton) {
        
        button.isSelected = !button.isSelected
        
        let section = button.tag
        guard var cartData = viewModel.cartDataSource else {return}
        cartData.store[section].isCheckoutSelected = button.isSelected
        
        var newlistItem : [CartItemDataSource] = []
        for item in cartData.store[section].cartItems {
            var newItem = item
            newItem.isSelected = button.isSelected
            newlistItem.append(newItem)
        }
        
        cartData.store[section].cartItems = newlistItem
        _CartServices.cartData.accept(cartData)
    }
    
    @objc private func voucherTapped() {
        let voucherVC = VoucherViewController()
        voucherVC.acceptance = _CartServices.voucherCode
        self.navigationController?.pushViewController(voucherVC, animated: true)
    }
    
    @objc private func checkoutButtonTapped() {
        //Handle checkout
//        viewModel.checkout()
        
        guard let cartDataSource = viewModel.cartDataSource else {return}
        
        let checkoutVC = CheckoutViewController.init(cartData: cartDataSource)
        self.navigationController?.pushViewController(checkoutVC, animated: true)
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
        }
        
        cell.delegate = self
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let checkboxButton = UIButton()
        checkboxButton.tintColor = kPrimaryColor
        checkboxButton.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkboxButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.tag = section
        checkboxButton.imageView?.contentMode = .scaleAspectFit
        checkboxButton.addTarget(self, action: #selector(storeCheckboxButtonTapped(button:)), for:.touchUpInside)
        headerView.addSubview(checkboxButton)
        checkboxButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(35)
        }
        
        if let storeData = _CartServices.cartData.value?.store[section] {
            let titleSignal = UILabel()
            titleSignal.text = storeData.storeDetails?.name ?? "Unknow Store Name"
            headerView.addSubview(titleSignal)
            titleSignal.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(checkboxButton.snp.right).offset(10)
                make.height.equalTo(30)
            }
            
            checkboxButton.isSelected = storeData.isCheckoutSelected
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            self.removeItemFromCart(indexPath)
            tableView.endUpdates()
        }
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
    
    func didUpdateItemQuanlity(_ index: IndexPath, newValue: Int) {
        guard let store = _CartServices.cartData.value?.store[index.section] else {return}
        let cartItem = store.cartItems[index.row]
        
        viewModel.updateCartItemsQuanlity(cartItem, newValue: newValue)
    }
}
