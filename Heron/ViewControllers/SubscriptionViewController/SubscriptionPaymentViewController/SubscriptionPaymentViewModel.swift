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
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
            return
        }
        
        self.controller?.startLoadingAnimation()
        _SubscriptionService.registerSubscriptionPlan(selectedPlan) { errorMessgae, value in
            self.controller?.endLoadingAnimation()
            print("")
        }
    }
}
