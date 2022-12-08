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
                        // swiftlint:disable line_length
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Payment successful!", comment: ""),
                                                             message: "You have successfully paid for the subscription. You now can check your subscription status in Profile Screen", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { _ in
                            alertVC.dismiss()
                            _NavController.gotoHomepage()
                        }))
                        _NavController.showAlert(alertVC)
                    case .canceled:
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Subscription Cancelled!", comment: ""),
                                                             message: "You have cancelled the current subscription immediatelly.", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { _ in
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
