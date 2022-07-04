//
//  SubcriptionViewModel.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import RxSwift
import RxRelay

class SubcriptionViewModel {
    public var subcriptions              = BehaviorRelay<[SubcriptionData]>(value: [])
    func getListSubscription()
    {
        _SubcriptionServices.getListSubscription { errorMessage, data in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let subcriptionList = data {
                self.subcriptions.accept(subcriptionList)
            }
    }
    }
        func sign_in(email: String, password: String, completion: @escaping ()->Void) {
            _AuthenticationServices.login(username: email, password: password) { isSuccess, errorMessgae in
                let defaults = UserDefaults.standard
//                defaults.set(true, forKey: "is_login")
                completion()
            }
        }
        
        func check_exists(email: String, password: String, completion: @escaping ()->Void) {
            _AuthenticationServices.checkExist(username: email, password: password) { isSuccess, errorMessgae in
                completion()
            }
        }
        
        func sign_up(username: String, passwd: String, fitst_name: String, last_name: String, gender: String, dob: Int, identityNum: String, phone: String, completion: @escaping ()->Void) {
            _AuthenticationServices.signUp(username: username, passwd: passwd, fitst_name: fitst_name, last_name: last_name, gender: gender, dob: dob, identityNum: identityNum, phone: phone) { isSuccess, errorMessage in
                completion()
            }
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
