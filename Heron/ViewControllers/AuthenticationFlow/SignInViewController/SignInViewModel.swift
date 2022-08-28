//
//  SignInViewModel.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit

class SignInViewModel: NSObject {

    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        _AuthenticationServices.login(username: email, password: password) { _, _ in
            completion()
        }
    }
    
    func checkExists(email: String, password: String, completion: @escaping () -> Void) {
        _AuthenticationServices.checkExist(username: email, password: password) { _, _ in
            completion()
        }
    }
}
