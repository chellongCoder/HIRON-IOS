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
                    return userSubscription.status == .ENABLED
                }) != nil {
                    // User already subscrible and plan
                    _NavController.gotoHomepage()
                    return
                }
                
                let pendingPlans = plans.filter { userSubscription in
                    return (userSubscription.status == .PENDING)
                }
                
                let viewController = MainSubscriptionViewController()
                viewController.viewModel.pendingSubscription.accept(pendingPlans)
                self.controller?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
