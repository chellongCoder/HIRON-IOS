//
//  UserProfileViewModel.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit
import RxRelay

class UserProfileViewModel: NSObject {
    
    weak var controller : UserProfileViewController?
    let userPlanString  = BehaviorRelay<String>(value: "User's plan")
    
    func getUserProfile() {
        _UserServices.getUserProfile()
    }
    
    func getUserSubscription() {
        _SubscriptionService.getUserRegisteredSubscriptionPlan { errorMessage, listUserSubs in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let currentlySubs = listUserSubs?.first(where: { userRegisteredSubscription in
                return userRegisteredSubscription.customStatus == .CURRENTLY_NS || userRegisteredSubscription.customStatus == .CURRENTLY_ST
            }) {
                self.userPlanString.accept(currentlySubs.subsPlan?.subsItem?.name ?? "User's plan")
                return
            }
            
            // Dont have any subscriptions
            self.userPlanString.accept("User's plan")
            
        }
    }
}
