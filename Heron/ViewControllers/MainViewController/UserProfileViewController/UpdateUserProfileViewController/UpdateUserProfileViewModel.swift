//
//  UpdateEHealthProfileViewModel.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit
import RxCocoa
import RxSwift
import Material

class UpdateUserProfileViewModel: NSObject {
    weak var controller : UpdateUserProfileViewController?
    var userData        = BehaviorRelay<UserDataSource?>(value: nil)
    private let disposeBag = DisposeBag()
    
    func getUserProfile() {
        _UserServices.getUserProfile()
        
        _AppCoreData.userDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.userData.accept(_AppCoreData.userDataSource.value)
            }
            .disposed(by: self.disposeBag)
    }
    
    func updateUserProfile(_ newUserProfile: UserDataSource) {
        self.controller?.startLoadingAnimation()
        _UserServices.updateUserProfile(newUserProfile) { errorMessage, isSuccess in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if isSuccess {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Done", comment: ""),
                                                     message: "User profile has updated !",
                                                     preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                    self.controller?.navigationController?.popToRootViewController(animated: true)
                }))
                _NavController.showAlert(alertVC)
            }
        }
    }
}
