//
//  CheckoutViewModel.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import RxRelay

class CheckoutViewModel: NSObject {

    public var deliveryAddress      = BehaviorRelay<ContactDataSource?>(value: nil)
    public var billingAddress       = BehaviorRelay<ContactDataSource?>(value: nil)
    public var voucherCode          = BehaviorRelay<VoucherDataSource?>(value: nil)
    public var reloadAnimation      = BehaviorRelay<Bool>(value: false)
    
    func checkout() {
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
    }
}
