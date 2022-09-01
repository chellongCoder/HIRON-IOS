//
//  SignInViewModel.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit
import RxCocoa

class SignInViewModel: NSObject {
    
    weak var controller     : SignInViewController?

    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        self.controller?.startLoadingAnimation()
        _AuthenticationServices.login(username: email, password: password) { errorMessage, _ in
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
    
    func checkExists(email: String, completion: @escaping () -> Void) {
        
        self.controller?.startLoadingAnimation()
        _AuthenticationServices.checkExist(username: email) { isExist in
            self.controller?.endLoadingAnimation()
            
            if isExist {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                     message: "This email already exist, please try to login.\n If you make sure this not you, you can contact our support at (chidoanh.com)",
                                                     preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            } else {
                completion()
            }
        }
    }
}
