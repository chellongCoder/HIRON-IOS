//
//  OrderViewModel.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import RxSwift
import RxRelay

class OrderViewModel: NSObject {

    public var cartData             = BehaviorRelay<CartDataSource?>(value: nil)
    public var deliveryAddress      = BehaviorRelay<ContactDataSource?>(value: nil)
    public var billingAddress       = BehaviorRelay<ContactDataSource?>(value: nil)
    public var voucherCode          = BehaviorRelay<VoucherDataSource?>(value: nil)
    public var reloadAnimation      = BehaviorRelay<Bool>(value: false)
    public var orders              = BehaviorRelay<[OrderData]>(value: [])
    
    func getMyOrder() {
        _OrderServices.getMyOrders(param: [:]) { errorMessage, newOrder in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let data = newOrder {
                self.orders.accept(data)
            }
        }
    }
    
//    func checkout() {
//        reloadAnimation.accept(true)
//        assert(cartData.value != nil, "Cart empty")
//
//        guard let cartData = self.cartData.value else {return}
//
//        _CartServices.checkout(cart: cartData) { errorMessage, successMessage in
//            self.reloadAnimation.accept(false)
//
//            if errorMessage != nil {
//                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
//                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
//                    alertVC.dismiss()
//                }))
//                _NavController.showAlert(alertVC)
//                return
//            }
//
//            //TODO: Clear cart
//            let alertVC = UIAlertController.init(title: NSLocalizedString("Alert", comment: ""), message: "Checkout success", preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
//                alertVC.dismiss()
//            }))
//            _NavController.showAlert(alertVC)
//        }
//    }
}
