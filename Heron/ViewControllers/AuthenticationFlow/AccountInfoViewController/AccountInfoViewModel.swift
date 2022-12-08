//
//  AccountInfoViewModel.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit
import RxRelay

class AccountInfoViewModel: NSObject {

    weak var controller : AccountInfoViewController?
    var userData        = BehaviorRelay<UserDataSource?>(value: nil)
    
    func signUp(completion: @escaping () -> Void) {
        
        guard let userData = userData.value else {return}
        self.controller?.startLoadingAnimation()
        _AuthenticationServices.signUp(userInfo: userData) { errorMessage, _ in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            completion()
        }
    }
}
