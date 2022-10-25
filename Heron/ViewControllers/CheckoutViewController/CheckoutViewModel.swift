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

    weak var controller             : CheckoutViewController?
    public var cartPreCheckout      : CartPrepearedResponseDataSource? = _CheckoutServices.cartPreCheckoutResponseData.value
    var listOrders                  : [OrderDataSource] = []
    
    func reloadPrecheckoutData() {
        controller?.startLoadingAnimation()
        _DeliveryServices.getListUserAddress { _, _ in
            self.controller?.endLoadingAnimation()
        }
    }
    
    func placeOrder() {
        
        self.controller?.startLoadingAnimation()
        _CheckoutServices.createOrder { errorMessage, paymentData, listOrders in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            self.listOrders = listOrders
            
            // Payment process
            if let paymentData = paymentData {
                guard let clientSecret = paymentData.metadata?.clientSecret else { return }
                guard let controller = self.controller else { return }

                _PaymentServices.payment(clientSecret, fromViewController: controller) { paymentResult in
                    switch paymentResult {
                    case .completed:
                        // clear checkout data
                        _CheckoutServices.checkoutSucess()
                        self.controller?.didFinishPlaceOrder()
                    case .canceled:
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Payment Cancelled", comment: ""),
                                                             message: "You have cancelled the payment.", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                            self.controller?.dismiss(animated: true)
                            // clear checkout data
                            _CheckoutServices.checkoutSucess()
                            _NavController.gotoProductListing()
                        }))
                        _NavController.showAlert(alertVC)
                    case .failed(let error):
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                             message: error.localizedDescription ,
                                                             preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                            // clear checkout data
                            _CheckoutServices.checkoutSucess()
                            _NavController.gotoProductListing()
                        }))
                        _NavController.showAlert(alertVC)
                    }
                }
            }
        }
    }
}
