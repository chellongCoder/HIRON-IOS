//
//  CheckoutViewController.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import RxRelay

class CheckoutViewController: BaseViewController {
    
    private let viewModel   =  CheckoutViewModel()
    
    private let deliveryTo      = AddressView()
    private let billingAddress  = AddressView()
    private let voucherView     = VoucherSelectedView()
    private let orderTotalView  = OrderTotalView()

    private let disposeBag      = DisposeBag()
    
    init(cartData: CartDataSource) {
        super.init(nibName: nil, bundle: nil)
        viewModel.cartData.accept(cartData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = kBackgroundColor
        navigationItem.title = "Checkout"
        
        let deliveryTouch = UITapGestureRecognizer.init(target: self, action: #selector(deliveryToTapped))
        deliveryTo.addGestureRecognizer(deliveryTouch)
        deliveryTo.addressTitle.text = "Delivery To"
        self.pageScroll.addSubview(deliveryTo)
        deliveryTo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
        }
        
        let billingTouch = UITapGestureRecognizer.init(target: self, action: #selector(billingAddressTapped))
        billingAddress.addGestureRecognizer(billingTouch)
        billingAddress.addressTitle.text = "Billing Address"
        self.pageScroll.addSubview(billingAddress)
        billingAddress.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(deliveryTo.snp.bottom).offset(10)
        }
        
        let voucherTouch = UITapGestureRecognizer.init(target: self, action: #selector(voucherTapped))
        voucherView.addGestureRecognizer(voucherTouch)
        self.pageScroll.addSubview(voucherView)
        voucherView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(billingAddress.snp.bottom).offset(10)
        }
        
        self.pageScroll.addSubview(orderTotalView)
        orderTotalView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(voucherView.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        self.bindingData()
    }
    
    //MARK: - Buttons
    @objc private func deliveryToTapped() {
        let userAddressesVC = UserAddressListingViewController()
        userAddressesVC.acceptance = viewModel.deliveryAddress
        self.navigationController?.pushViewController(userAddressesVC, animated: true)
    }
    
    @objc private func billingAddressTapped() {
        let userAddressesVC = UserAddressListingViewController()
        userAddressesVC.acceptance = viewModel.billingAddress
        self.navigationController?.pushViewController(userAddressesVC, animated: true)
    }
    
    @objc private func voucherTapped() {
        
    }
    
    @objc private func placeOrderTapped() {
        
    }
    
    //MARK: - BindingData
    func bindingData() {
        viewModel.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                
                guard let cartData = cartDataSource.element as? CartDataSource else {return}
                self.orderTotalView.subTotalValue.text = String(format: "$%ld", cartData.grandTotal)
                self.orderTotalView.discountValue.text = String(format: "$%ld", (cartData.subtotal - cartData.grandTotal))                
            }
            .disposed(by: disposeBag)
        
        viewModel.deliveryAddress
            .observe(on: MainScheduler.instance)
            .subscribe { deliveryAddress in
                
                guard let deliveryAddress = deliveryAddress.element as? ContactDataSource else {return}
                self.deliveryTo.contactLabel.text = deliveryAddress.firstName + " | +" + deliveryAddress.phone
                self.deliveryTo.addressLabel.text = deliveryAddress.address + deliveryAddress.province + deliveryAddress.postalCode
            }
            .disposed(by: disposeBag)
        
        viewModel.billingAddress
            .observe(on: MainScheduler.instance)
            .subscribe { billingAddress in
                
                guard let billingAddress = billingAddress.element as? ContactDataSource else {return}
                self.deliveryTo.contactLabel.text = billingAddress.firstName + billingAddress.phone
                self.deliveryTo.contactLabel.text = billingAddress.address + billingAddress.province + billingAddress.postalCode
            }
            .disposed(by: disposeBag)
        
        viewModel.voucherCode
            .observe(on: MainScheduler.instance)
            .subscribe { voucherCode in
                guard let voucherCode = voucherCode.element as? String else {return}
                self.voucherView.voucherCode.text = voucherCode
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
}
