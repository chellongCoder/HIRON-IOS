//
//  CheckoutViewController.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import RxRelay

class CheckoutViewController: BaseViewController,
                            UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel   =  CheckoutViewModel()
    
    private let deliveryTo      = AddressView()
    private let billingAddress  = AddressView()
    private let voucherView     = VoucherSelectedView()
    private let orderTotalView  = OrderTotalView()

    private let totalLabel      = UILabel()
//    private let savingLabel     = UILabel()
    private let placeOrderBtn   = UIButton()
    
    private let tableView       = UITableView.init(frame: .zero, style: .grouped)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kBackgroundColor
        navigationItem.title = "Checkout"
        
        self.viewModel.controller = self
        self.showBackBtn()
        
        let supportBtn = UIBarButtonItem.init(image: UIImage.init(named: "customer_support_icon"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(customerSupportButtonTapped))
        self.navigationItem.rightBarButtonItem = supportBtn
        
        // MARK: - Bottom
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
//        savingLabel.text = "Saving: $0.0"
//        savingLabel.textColor = kDefaultTextColor
//        savingLabel.font = .systemFont(ofSize: 16)
//        bottomView.addSubview(savingLabel)
//        savingLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(20)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
//        }
        
        totalLabel.text = "$0.0"
        totalLabel.textColor = kDefaultTextColor
        totalLabel.font = getCustomFont(size: 16, name: .extraBold)
        bottomView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(25)
        }
        
        placeOrderBtn.backgroundColor = kPrimaryColor
        placeOrderBtn.setTitleColor(.white, for: .normal)
        placeOrderBtn.setTitle("Place Order", for: .normal)
        placeOrderBtn.titleLabel?.textColor = .white
        placeOrderBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        placeOrderBtn.layer.cornerRadius = 20
        placeOrderBtn.addTarget(self, action: #selector(placeOrderTapped), for: .touchUpInside)
        bottomView.addSubview(placeOrderBtn)
        placeOrderBtn.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel.snp.centerY)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(160)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        let line = UIView()
        
        line.backgroundColor = kDisableColor
        bottomView.addSubview(line)
        line.snp.makeConstraints { make in
            make.bottom.equalTo(placeOrderBtn.snp.top).offset(-12)
            make.height.equalTo(0.5)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(CheckoutItemTableViewCell.self, forCellReuseIdentifier: "CheckoutItemTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        self.viewModel.reloadPrecheckoutData()
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
        
        if (_CheckoutServices.cartPreCheckoutResponseData.value?.checkoutPriceData?.customShippingSubtotal ?? 0) == 0 {
            self.placeOrderBtn.isUserInteractionEnabled = false
            self.placeOrderBtn.backgroundColor = kDisableColor
            return
        }
                
        self.endLoadingAnimation()
        placeOrderBtn.isUserInteractionEnabled = true
        placeOrderBtn.backgroundColor = kPrimaryColor
    }
    
    // MARK: - Buttons
    @objc private func customerSupportButtonTapped() {
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
    
    @objc private func deliveryToTapped() {
        let userAddressesVC = UserAddressListingViewController()
        userAddressesVC.acceptance = _CheckoutServices.deliveryAddress
        self.navigationController?.pushViewController(userAddressesVC, animated: true)
    }
    
    @objc private func billingAddressTapped() {
        
    }
    
    @objc private func voucherTapped() {
        // Fixing issue: 8336] [App][Checkout] Mục Voucher tại màn hình check out chỉ được view không được chọn voucher
//        let voucherVC = VoucherViewController()
//        voucherVC.acceptance = _CartServices.voucherCode
//        self.navigationController?.pushViewController(voucherVC, animated: true)
    }
    
    @objc private func placeOrderTapped() {
        viewModel.placeOrder()
    }
    
    func didFinishPlaceOrder() {
        let successVC = SuccessPlaceOrderViewController()
        successVC.listOrders = self.viewModel.listOrders
        self.navigationController?.pushViewController(successVC, animated: true)
    }
    
    // MARK: - BindingData
    override func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                
                guard let cartData = cartDataSource.element as? CartDataSource else {return}
                self.orderTotalView.subTotalValue.text = getMoneyFormat(cartData.customSubTotal)
                self.orderTotalView.discountValue.text = getMoneyFormat((cartData.customSubTotal - cartData.customGrandTotal))
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
                    
                    self.totalLabel.text = "$0.0"
//                    self.savingLabel.text = "Saving $0.0"
                    
                    return
                }
                
                self.orderTotalView.subTotalValue.text = getMoneyFormat(cartPreCheckoutDataSource.checkoutPriceData?.customMerchandiseSubtotal)
                self.orderTotalView.discountValue.text = getMoneyFormat(cartPreCheckoutDataSource.checkoutPriceData?.customCouponApplied)
                self.orderTotalView.shippingAndTaxValue.text = getMoneyFormat((cartPreCheckoutDataSource.checkoutPriceData?.customShippingSubtotal ?? 0.0) +
                                                                              (cartPreCheckoutDataSource.checkoutPriceData?.customTaxPayable ?? 0.0))
                self.totalLabel.text = String(format: "%@", getMoneyFormat(cartPreCheckoutDataSource.checkoutPriceData?.customTotalPayable))
//                self.savingLabel.text = String(format: "Saving: %@", getMoneyFormat(cartPreCheckoutDataSource.checkoutPriceData?.customCouponApplied))
                
                self.viewModel.cartPreCheckout = cartPreCheckoutDataSource
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        _CheckoutServices.deliveryAddress
            .observe(on: MainScheduler.instance)
            .subscribe { deliveryAddress in
                
                self.updatePlaceOrderButton()
                guard let deliveryAddress = deliveryAddress.element as? ContactDataSource else {
                    self.deliveryTo.contactLabel.text = "Please select your Delivery Address"
                    self.deliveryTo.addressLabel.text = nil
                    return
                }
                self.deliveryTo.contactLabel.text = String(format: "%@ %@ - %@",
                                                           deliveryAddress.firstName,
                                                           deliveryAddress.lastName,
                                                           deliveryAddress.phone)
                self.deliveryTo.addressLabel.text = deliveryAddress.address + ", " + deliveryAddress.province + ", " + deliveryAddress.country + ", " + deliveryAddress.postalCode
                
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        _CheckoutServices.billingAddress
            .observe(on: MainScheduler.instance)
            .subscribe { billingAddress in
                self.updatePlaceOrderButton()
                guard let billingAddress = billingAddress.element as? UserDataSource else { return }
                self.billingAddress.contactLabel.text = String(format: "%@ %@ | %@%@",
                                                               billingAddress.userFirstName,
                                                               billingAddress.userLastName,
                                                               billingAddress.userPhoneCode,
                                                               billingAddress.userPhoneNum)
                // billingAddress.userFullName + " | " + billingAddress.userPhoneNum
                self.billingAddress.addressLabel.text = billingAddress.userEmail
                
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        _CartServices.voucherCode
            .observe(on: MainScheduler.instance)
            .subscribe { voucherDataSource in
                self.voucherView.setVoucherData(voucherDataSource.element as? VoucherDataSource)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel.cartPreCheckout?.cartDetail.count ?? 0) + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // shipping address and billing address
            return 1
        } else if section == (viewModel.cartPreCheckout?.cartDetail.count ?? 0) + 1 {
            // Voucher and total
            return 2
        } else {
            // Store
            let cartDetail = viewModel.cartPreCheckout?.cartDetail[section - 1]
            return cartDetail?.cartItems.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // Delivery Address
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
                
                deliveryTo.addressTitle.text = "Delivery Information"
                cell.addSubview(deliveryTo)
                deliveryTo.snp.makeConstraints { (make) in
                    make.center.size.equalToSuperview()
                }
                
                return cell
            } else {
                // Billing Address
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
                
                billingAddress.addressTitle.text = "Billing Address"
                cell.addSubview(billingAddress)
                billingAddress.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(10)
                    make.top.equalToSuperview().offset(2)
                    make.center.equalToSuperview()
                }
                
                return cell
                
            }
        } else if indexPath.section == (viewModel.cartPreCheckout?.cartDetail.count ?? 0) + 1 {
            // Voucher and total
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
            cell.backgroundColor = kBackgroundColor
            
            if indexPath.row == 0 {
                
                let spacer = UIView()
                spacer.backgroundColor = UIColor.init(hexString: "efefef")
                cell.addSubview(spacer)
                spacer.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.height.equalTo(6)
                }
                
                // Total order
                cell.addSubview(orderTotalView)
                orderTotalView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(10)
                    make.top.equalTo(spacer.snp.bottom).offset(2)
                    make.center.equalToSuperview()
                }
                
            } else {
                
                let spacer = UIView()
                spacer.backgroundColor = UIColor.init(hexString: "efefef")
                cell.addSubview(spacer)
                spacer.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.height.equalTo(6)
                }
                
                // Voucher
                cell.addSubview(voucherView)
                voucherView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(10)
                    make.top.equalTo(spacer.snp.bottom).offset(2)
                    make.center.equalToSuperview()
                }
            }
            
            return cell
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
        
        if section == 0 || section == (viewModel.cartPreCheckout?.cartDetail.count ?? 0) + 1 {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
                
        if let storeData = viewModel.cartPreCheckout?.cartDetail[section - 1] {
            
            let spacer = UIView()
            spacer.backgroundColor = UIColor.init(hexString: "efefef")
            headerView.addSubview(spacer)
            spacer.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(-18)
                make.left.right.equalToSuperview()
                make.height.equalTo(6)
            }
            
            let titleSignal = UILabel()
            titleSignal.text = storeData.storeDetails?.name ?? "Unknow Store Name"
            titleSignal.font = getCustomFont(size: 13, name: .bold)
            titleSignal.textColor = kTitleTextColor
            headerView.addSubview(titleSignal)
            titleSignal.snp.makeConstraints { make in
                make.top.equalTo(spacer.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(16)
                make.right.bottom.equalToSuperview()
                make.height.equalTo(13)
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 || section == (viewModel.cartPreCheckout?.cartDetail.count ?? 0) + 1 {
            return UIView()
        }
        
        let footerView = UIView()
        footerView.backgroundColor = kBackgroundColor
        
        if let storeData = viewModel.cartPreCheckout?.cartDetail[section - 1],
           let shippingData = storeData.shippingOrder,
           let qoutes = shippingData.qoutes,
           let carier = shippingData.carrier {
            
            let spacer = UIView()
            spacer.backgroundColor = UIColor.init(hexString: "efefef")
            footerView.addSubview(spacer)
            spacer.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(6)
            }
            
            let titleSignal = UILabel()
            titleSignal.text = "Carrier information"
            titleSignal.textColor = kDefaultTextColor
            titleSignal.font = getCustomFont(size: 13, name: .bold)
            footerView.addSubview(titleSignal)
            titleSignal.snp.makeConstraints { make in
                make.top.equalTo(spacer.snp.bottom).offset(20)
                make.right.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.height.equalTo(13)
            }
            
            let carierView = CarrierView()
            carierView.carrierName.text = carier.name
            carierView.priceLabel.text = getMoneyFormat(shippingData.amount)
            carierView.receivedLog.text = String(format: "Receive order on %@", qoutes.updatedAtStr)
            footerView.addSubview(carierView)
            carierView.snp.makeConstraints { (make) in
                make.top.equalTo(titleSignal.snp.bottom)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            }
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.deliveryToTapped()
            } else {
                return
                // Disable edit billing address
                // self.billingAddressTapped()
            }
        }
    }
}
