//
//  SubscriptionPaymentViewModel.swift
//  Heron
//
//  Created by Luu Luc on 25/08/2022.
//

import UIKit
import RxRelay

class SubscriptionPaymentViewModel: NSObject {
    weak var controller     : SubscriptionPaymentViewController?
    let subscriptionPlan    = BehaviorRelay<SubscriptionData?>(value: nil)
    
    func checkoutSubscription() {
        
        guard let selectedPlan = self.subscriptionPlan.value else {
            let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                 message: "Subscription Plan not found", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
            return
        }
        
        self.controller?.startLoadingAnimation()
        _SubscriptionService.registerSubscriptionPlan(selectedPlan) { errorMessage, userSubscription in
            self.controller?.endLoadingAnimation()
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let userSubscription = userSubscription {
                guard let paymentIntentClientSecret = userSubscription.payment?.metadata?.clientSecret else {
                    _NavController.gotoHomepage()
                    return
                }
                
                guard let controller = self.controller else { return }

                _PaymentServices.payment(paymentIntentClientSecret, fromViewController: controller) { paymentResult in
                    // Check payment status
                    switch paymentResult {
                    case .completed:
                        _NavController.gotoHomepage()
                    case .canceled:
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Cancelled", comment: ""),
                                                             message: "You has cancelled payment, you can continue buy subscription in User Profile page", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Skip", comment: ""), style: .cancel, handler: { _ in
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
                        }))
                        _NavController.showAlert(alertVC)
                    }
                }
            }
        }
    }
}
