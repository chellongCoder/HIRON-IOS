//
//  BookingViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxCocoa

class BookingViewModel: BaseViewModel {
    
    weak var controller     : BookingViewController?

    func getUserEHealthProfiles() {
        self.controller?.startLoadingAnimation()
        
        _EHProfileServices.getListEHProfile { errorMessage in
            self.controller?.endLoadingAnimation()
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if _EHProfileServices.listProfiles.value.isEmpty {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                     message: "User do not have any EHP",
                                                     preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }   
        }
    }
}
