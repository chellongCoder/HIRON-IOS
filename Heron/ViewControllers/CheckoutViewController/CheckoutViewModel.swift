//
//  CheckoutViewModel.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import RxRelay

protocol CheckoutViewModelDelegate : AnyObject {
    func didFinishPlaceOrder()
}

class CheckoutViewModel: NSObject {

    public var reloadAnimation      = BehaviorRelay<Bool>(value: false)
    public var cartPreCheckout      : CartPrepearedResponseDataSource? = _CheckoutServices.cartPreCheckoutResponseData.value
    public var delegate             : CheckoutViewModelDelegate?
    
    func reloadPrecheckoutData() {
        _DeliveryServices.getListUserAddress()
    }
    
    func placeOrder() {
        
        reloadAnimation.accept(true)
        _CheckoutServices.createOrder { errorMessage, _ in
            self.reloadAnimation.accept(false)
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            // clear checkout data
            _CheckoutServices.cartPreCheckoutResponseData.accept(nil)
            self.delegate?.didFinishPlaceOrder()
        }
    }
}
