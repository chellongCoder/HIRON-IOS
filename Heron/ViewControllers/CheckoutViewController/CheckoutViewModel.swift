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
    var listOrders                  : [OrderDataSource] = []
    
    func reloadPrecheckoutData() {
        _DeliveryServices.getListUserAddress()
    }
    
    func placeOrder() {
        
        self.reloadAnimation.accept(true)
        _CheckoutServices.createOrder { errorMessage, paymentData, listOrders in
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
            
            self.listOrders = listOrders
            
            // Payment process
            if let paymentData = paymentData {
                guard let clientSecret = paymentData.metadata?.clientSecret else { return }
                _PaymentServices.payment(clientSecret) { paymentResult in
                    switch paymentResult {
                    case .completed:
                        self.delegate?.didFinishPlaceOrder()
                    case .canceled:
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Cancelled", comment: ""),
                                                             message: "You has cancelled payment, you can try again", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                            _NavController.gotoHomepage()
                        }))
                        _NavController.showAlert(alertVC)
                    case .failed(let error):
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                             message: error.localizedDescription ,
                                                             preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                            _NavController.gotoHomepage()
                        }))
                        _NavController.showAlert(alertVC)
                    }
                }
            }
        }
    }
}
