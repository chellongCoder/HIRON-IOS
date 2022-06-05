//
//  VM_Auth.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class VM_Auth {

        func sign_in(email: String, password: String, completion: @escaping ()->Void) {
            _AuthenticationServices.login { isSuccess, errorMessgae in
                completion()
            }
        }
        
        func check_exists(email: String, password: String, completion: @escaping ()->Void) {
            _AuthenticationServices.login { isSuccess, errorMessgae in
                completion()
            }
        }
        
        func sign_up(username: String, passwd: String, fitst_name: String, last_name: String, gender: String, dob: Int, identityNum: String, phone: String, completion: @escaping ()->Void) {
//            isLoading.value = true
//            networkAgent.sign_up(username: username, passwd: passwd, fitst_name: fitst_name, last_name: last_name, gender: gender, dob: dob, identityNum: identityNum, phone: phone)
//                .subscribeOn(MainScheduler.instance)
//                .subscribe(onNext: { response in
//                    self.isLoading.value = false
//                    if let user = response.data {
//                        completion()
//                    }
//                }, onError: { error in
//                    self.handleError(error)
//                }, onCompleted: nil)
//                .disposed(by: disposeBag)
//        }
        }


}
