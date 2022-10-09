//
//  UserSubscriptionViewModel.swift
//  Heron
//
//  Created by Luu Luc on 28/08/2022.
//

import UIKit
import RxRelay

class UserSubscriptionViewModel: NSObject {
    weak var controller         : UserSubscriptionViewController?
    let listUserSunscriptions   = BehaviorRelay<[UserRegisteredSubscription]>(value: [])
    
    func getListUserSubscriptions() {
        _SubscriptionService.getUserRegisteredSubscriptionPlan { errorMessage, plans in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if var plans = plans {
                plans = plans.filter({ userRegisteredSubscription in
                    // filter not pending
                    return userRegisteredSubscription.getStatusText() != "Under Payment"
                })
                self.listUserSunscriptions.accept(plans)
            }
        }
    }
    
    func cancelCurrentlySubscription(_ immediately: Bool) {
        
        if let firstCurrentSubscription = self.listUserSunscriptions.value.first(where: { userSubsction in
            return userSubsction.customStatus == .CURRENTLY_NS
        }) {
            
            if immediately {
                
                self.controller?.startLoadingAnimation()
                _SubscriptionService.cancelImmediatelySubscription(firstCurrentSubscription) { errorMessage, _ in
                    self.controller?.endLoadingAnimation()
                    
                    if errorMessage != nil {
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                        }))
                        _NavController.showAlert(alertVC)
                        return
                    }
                    
                    self.getListUserSubscriptions()
                }
                
            } else {
                self.controller?.startLoadingAnimation()
                _SubscriptionService.cancelAutoRenewableSubscription(firstCurrentSubscription) { errorMessage, _ in
                    self.controller?.endLoadingAnimation()
                    
                    if errorMessage != nil {
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                        }))
                        _NavController.showAlert(alertVC)
                        return
                    }
                    
                    self.getListUserSubscriptions()
                }
            }
        }
    }
}
