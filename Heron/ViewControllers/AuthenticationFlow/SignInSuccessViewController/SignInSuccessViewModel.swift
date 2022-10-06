//
//  SignInSuccessViewModel.swift
//  Heron
//
//  Created by Luu Luc on 26/08/2022.
//

import UIKit

class SignInSuccessViewModel: NSObject {
    weak var controller : SignInSuccessViewController?
    
    func checkUserSubscriptionPlan() {
        self.controller?.startLoadingAnimation()
        _SubscriptionService.getUserRegisteredSubscriptionPlan { errorMessage, plans in
            self.controller?.endLoadingAnimation()
            if errorMessage != nil {
                _NavController.gotoHomepage()
                return
            }
            
            if let plans = plans {
                
                if plans.first(where: { userSubscription in
                    return userSubscription.customStatus == .CURRENTLY_NS || userSubscription.customStatus == .CURRENTLY_ST
                }) != nil {
                    // User already subscrible and it never Stop
                    _NavController.gotoHomepage()
                    return
                }
                
//                if plans.contains(where: { userSubscription in
//                    return userSubscription.customStatus == .CURRENTLY_ST
//                }) {
//                    if plans.contains(where: { userSubscription2 in
//                        return userSubscription2.customStatus == .WILL_ACTIVE
//                    }) {
//                        // User already subscrible and has switched plan
//                        _NavController.gotoHomepage()
//                        return
//                    }
//                }
                
                let viewController = MainSubscriptionViewController()
                self.controller?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
