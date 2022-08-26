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
                let filteredPlan = plans.filter { userSuscription in
                    return (userSuscription.status == .ENABLED || userSuscription.status == .PENDING)
                }
                
                if filteredPlan.isEmpty {
                    let viewController = MainSubscriptionViewController()
                    self.controller?.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    _NavController.gotoHomepage()
                }
            }
        }
    }
}
