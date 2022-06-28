//
//  CheckoutViewController.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import RxRelay

class CheckoutViewController: UIViewController,
                            UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel   =  CheckoutViewModel()
    
    private let deliveryTo      = AddressView()
    private let billingAddress  = AddressView()
    private let voucherView     = VoucherSelectedView()
    private let orderTotalView  = OrderTotalView()

    private let totalLabel      = UILabel()
    private let savingLabel     = UILabel()
    private let placeOrderBtn   = UIButton()
    
    private let tableView       = UITableView.init(frame: .zero, style: .grouped)
    
    private let disposeBag      = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = kBackgroundColor
        navigationItem.title = "Checkout"
        
        self.viewModel.delegate = self
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
//        let deliveryTouch = UITapGestureRecognizer.init(target: self, action: #selector(deliveryToTapped))
//        deliveryTo.addGestureRecognizer(deliveryTouch)
//        deliveryTo.addressTitle.text = "Delivery To"
//        self.view.addSubview(deliveryTo)
//        deliveryTo.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
//            make.top.equalToSuperview().offset(2)
//        }
//
//        let billingTouch = UITapGestureRecognizer.init(target: self, action: #selector(billingAddressTapped))
//        billingAddress.addGestureRecognizer(billingTouch)
//        billingAddress.addressTitle.text = "Billing Address"
//        self.view.addSubview(billingAddress)
//        billingAddress.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
//            make.top.equalTo(deliveryTo.snp.bottom).offset(2)
//        }
        
        
        // MARK: - Bottom
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        savingLabel.text = "Saving: $0.0"
        savingLabel.textColor = kDefaultTextColor
        savingLabel.font = .systemFont(ofSize: 16)
        bottomView.addSubview(savingLabel)
        savingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        totalLabel.text = "Total: $0.0"
        totalLabel.textColor = kDefaultTextColor
        totalLabel.font = .systemFont(ofSize: 20)
        totalLabel.adjustsFontSizeToFitWidth = false
        totalLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        bottomView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.bottom.equalTo(savingLabel.snp.top).offset(-5)
            make.left.equalToSuperview().offset(20)
        }
        
        placeOrderBtn.backgroundColor = kPrimaryColor
        placeOrderBtn.setTitleColor(.white, for: .normal)
        placeOrderBtn.setTitle("Place Order", for: .normal)
        placeOrderBtn.layer.cornerRadius = 8
        placeOrderBtn.setContentHuggingPriority(.defaultLow, for: .horizontal)
        placeOrderBtn.addTarget(self, action: #selector(placeOrderTapped), for: .touchUpInside)
        bottomView.addSubview(placeOrderBtn)
        placeOrderBtn.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.top)
            make.bottom.equalTo(savingLabel.snp.bottom)
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(totalLabel.snp.right).offset(15)
            make.top.equalToSuperview().offset(10)
        }
        
        self.view.addSubview(orderTotalView)
        orderTotalView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(bottomView.snp.top).offset(-2)
        }
        
        let voucherTouch = UITapGestureRecognizer.init(target: self, action: #selector(voucherTapped))
        voucherView.addGestureRecognizer(voucherTouch)
        self.view.addSubview(voucherView)
        voucherView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(orderTotalView.snp.top).offset(-2)
        }
        
        self.view.layoutIfNeeded()
//
//        let tableViewContent = UIView()
//        tableViewContent.backgroundColor = .red
//        tableViewContent.setContentHuggingPriority(.defaultLow, for: .vertical)
//        self.view.addSubview(tableViewContent)
//        tableViewContent.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.greaterThanOrEqualTo(billingAddress.snp.bottom).offset(10)
//            make.bottom.lessThanOrEqualTo(voucherView.snp.top).offset(-10)
//        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(CheckoutItemTableViewCell.self, forCellReuseIdentifier: "CheckoutItemTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(voucherView.snp.top).offset(-10)
        }
        
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadPrecheckoutData()
    }
    
    // MARK: - UI
    
    func updatePlaceOrderButton() {
        if _CheckoutServices.billingAddress.value == nil {
            self.placeOrderBtn.isUserInteractionEnabled = false
            self.placeOrderBtn.backgroundColor = kDisableColor
            return
        }
        
        if _CheckoutServices.deliveryAddress.value == nil {
            self.placeOrderBtn.isUserInteractionEnabled = false
            self.placeOrderBtn.backgroundColor = kDisableColor
            return
        }
        
        if _CheckoutServices.cartPreCheckoutResponseData.value == nil {
            self.placeOrderBtn.isUserInteractionEnabled = false
            self.placeOrderBtn.backgroundColor = kDisableColor
            return
        }
        
        placeOrderBtn.isUserInteractionEnabled = true
        placeOrderBtn.backgroundColor = kPrimaryColor
    }
    
    //MARK: - Buttons
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func deliveryToTapped() {
        let userAddressesVC = UserAddressListingViewController()
        userAddressesVC.acceptance = _CheckoutServices.deliveryAddress
        self.navigationController?.pushViewController(userAddressesVC, animated: true)
    }
    
    @objc private func billingAddressTapped() {
        let userAddressesVC = UserAddressListingViewController()
        userAddressesVC.acceptance = _CheckoutServices.billingAddress
        self.navigationController?.pushViewController(userAddressesVC, animated: true)
    }
    
    @objc private func voucherTapped() {
        let voucherVC = VoucherViewController()
        voucherVC.acceptance = _CartServices.voucherCode
        self.navigationController?.pushViewController(voucherVC, animated: true)
    }
    
    @objc private func placeOrderTapped() {
        viewModel.placeOrder()
    }
    
    //MARK: - BindingData
    func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                
                guard let cartData = cartDataSource.element as? CartDataSource else {return}
                self.orderTotalView.subTotalValue.text = String(format: "$%.2f", cartData.customSubTotal)
                self.orderTotalView.discountValue.text = String(format: "$%.2f", (cartData.customSubTotal - cartData.customGrandTotal))
                self.orderTotalView.totalValue.text = String(format: "$%.2f", cartData.customGrandTotal)
            }
            .disposed(by: disposeBag)
        
        _CheckoutServices.cartPreCheckoutResponseData
            .observe(on: MainScheduler.instance)
            .subscribe { cartPreCheckoutDataSource in
                
                self.updatePlaceOrderButton()
                
                guard let cartPreCheckoutDataSource = cartPreCheckoutDataSource.element as? CartPrepearedResponseDataSource else {
                    self.orderTotalView.subTotalValue.text = "$0.0"
                    self.orderTotalView.discountValue.text = "$0.0"
                    self.orderTotalView.shippingAndTaxValue.text = "$0.0"
                    self.orderTotalView.totalValue.text = "$0.0"
                    
                    self.totalLabel.text = "Total: $0.0"
                    self.savingLabel.text = "Saving: $0.0"
                    
                    return
                }
                
                self.orderTotalView.subTotalValue.text = String(format: "$%.2f", cartPreCheckoutDataSource.checkoutPriceData?.customMerchandiseSubtotal ?? 0.0)
                self.orderTotalView.discountValue.text = String(format: "$%.2f", cartPreCheckoutDataSource.checkoutPriceData?.customCouponApplied ?? 0.0)
                self.orderTotalView.shippingAndTaxValue.text = String(format: "$%.2f", (cartPreCheckoutDataSource.checkoutPriceData?.customShippingSubtotal ?? 0.0) + (cartPreCheckoutDataSource.checkoutPriceData?.customTaxPayable ?? 0.0))
                self.orderTotalView.totalValue.text = String(format: "$%.2f", cartPreCheckoutDataSource.checkoutPriceData?.customTotalPayable ?? 0.0)
                self.totalLabel.text = String(format: "Total: $%.2f", cartPreCheckoutDataSource.checkoutPriceData?.customTotalPayable ?? 0.0)
                self.savingLabel.text = String(format: "Saving: $%.2f", cartPreCheckoutDataSource.checkoutPriceData?.customCouponApplied ?? 0.0)
                
                self.viewModel.cartPreCheckout = cartPreCheckoutDataSource
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        _CheckoutServices.deliveryAddress
            .observe(on: MainScheduler.instance)
            .subscribe { deliveryAddress in
                
                self.updatePlaceOrderButton()
                guard let deliveryAddress = deliveryAddress.element as? ContactDataSource else {return}
                self.deliveryTo.contactLabel.text = deliveryAddress.firstName + " | +" + deliveryAddress.phone
                self.deliveryTo.addressLabel.text = deliveryAddress.address + ", " + deliveryAddress.province + ", " + deliveryAddress.country + ", " + deliveryAddress.postalCode
                
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        _CheckoutServices.billingAddress
            .observe(on: MainScheduler.instance)
            .subscribe { billingAddress in
                self.updatePlaceOrderButton()
                guard let billingAddress = billingAddress.element as? ContactDataSource else {return}
                self.billingAddress.contactLabel.text = billingAddress.firstName + billingAddress.phone
                self.billingAddress.addressLabel.text = billingAddress.address + ", " + billingAddress.province + ", " + billingAddress.country + ", " + billingAddress.postalCode
                
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
        
        viewModel.reloadAnimation
            .observe(on: MainScheduler.instance)
            .subscribe { isLoading in
                if (isLoading.element ?? false) {
                    self.startLoadingAnimation()
                } else {
                    self.endLoadingAnimation()
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel.cartPreCheckout?.cartDetail.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            let cartDetail = viewModel.cartPreCheckout?.cartDetail[section - 1]
            return cartDetail?.cartItems.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // Delivery Address
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
                cell.backgroundColor = kBackgroundColor
                
                deliveryTo.addressTitle.text = "Delivery To"
                cell.addSubview(deliveryTo)
                deliveryTo.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(10)
                    make.top.equalToSuperview().offset(2)
                    make.center.equalToSuperview()
                }
                
                return cell
            } else {
                // Billing Address
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
                cell.backgroundColor = kBackgroundColor
                
                billingAddress.addressTitle.text = "Billing Address"
                cell.addSubview(billingAddress)
                billingAddress.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(10)
                    make.top.equalToSuperview().offset(2)
                    make.center.equalToSuperview()
                }
                
                return cell
                
            }
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutItemTableViewCell") as? CheckoutItemTableViewCell
            
            if cell == nil {
                cell = CheckoutItemTableViewCell.init(style: .default, reuseIdentifier: "CheckoutItemTableViewCell")
            }
            
            if let cartDetail = viewModel.cartPreCheckout?.cartDetail[indexPath.section - 1] {
                let cellData = cartDetail.cartItems[indexPath.row]
                cell!.setDataSource(itemData: cellData, index: indexPath)
            }
            
            return cell!
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
                
        if let storeData = viewModel.cartPreCheckout?.cartDetail[section - 1] {
            let titleSignal = UILabel()
            titleSignal.text = storeData.storeDetails?.name ?? "Unknow Store Name"
            headerView.addSubview(titleSignal)
            titleSignal.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(30)
                make.top.bottom.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        }
        
        let footerView = UIView()
        footerView.backgroundColor = kBackgroundColor
        
        let contentFooterView = UIView()
        contentFooterView.backgroundColor = .white
        footerView.addSubview(contentFooterView)
        contentFooterView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview()
        }
        
        if let storeData = viewModel.cartPreCheckout?.cartDetail[section - 1],
           let shippingData = storeData.shippingOrder,
           let carier = shippingData.carrier {
            
            let titleSignal = UILabel()
            titleSignal.text = "Shipping & Handling informations"
            contentFooterView.addSubview(titleSignal)
            titleSignal.snp.makeConstraints { make in
                make.top.right.equalToSuperview()
                make.left.equalToSuperview().offset(30)
                make.height.equalTo(50)
            }
            
            let carierView = CarrierView()
            carierView.carrierName.text = carier.name
            carierView.shippingFee.text = String(format: "$%.2f", shippingData.amount)
            carierView.receivedLog.text = String(format: "Received order in %@", carier.updatedAtStr)
            contentFooterView.addSubview(carierView)
            carierView.snp.makeConstraints { (make) in
                make.top.equalTo(titleSignal.snp.bottom).offset(2)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
            
            let orderSum = OrderSumView()
            orderSum.orderSumValue.text = String(format: "$%.2f", storeData.customOrderTotal)
            contentFooterView.addSubview(orderSum)
            orderSum.snp.makeConstraints { (make) in
                make.top.equalTo(carierView.snp.bottom).offset(2)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            }
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.deliveryToTapped()
            } else {
                self.billingAddressTapped()
            }
        }
    }
}

extension CheckoutViewController : CheckoutViewModelDelegate {
    func didFinishPlaceOrder() {
        self.navigationController?.pushViewController(SuccessPlaceOrderViewController(), animated: true)
    }
}