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
            
            if let plans = plans {
                self.listUserSunscriptions.accept(plans)
            }
        }
    }
    
    func getCurrentSubscription(_ listSubscription: [UserRegisteredSubscription]) -> UserRegisteredSubscription? {
        
        return self.listUserSunscriptions.value.first { userSubsction in
            return (userSubsction.isCurrentlyApplied())
        }
    }
    
    func cancelCurrentlySubscription(_ immediately: Bool) {
        if let firstCurrentSubscription = self.listUserSunscriptions.value.first(where: { userSubsction in
            return (userSubsction.isCurrentlyApplied())
        }) {
            
            if firstCurrentSubscription.status == .CANCELLED {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                     message: "Your subscription is currently cancelled",
                                                     preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
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
