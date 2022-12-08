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
                                                     message: "This email already exists, please try to login.\nIf you already forgot your password, contact our support at Chidoanh.com!\nThank you.",
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
