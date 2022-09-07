//
//  UpdateEHProfileViewModel.swift
//  Heron
//
//  Created by Luu Luc on 05/09/2022.
//

import UIKit
import RxRelay

class UpdateEHProfileViewModel: NSObject {
    
    weak var controller : UpdateEHProfileViewController?
    
    func getUserEHProfile() {
        _EHProfileServices.getListEHProfile { errorMessage in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
        }
    }
    
    func updateRootEHProfile(_ ehProfile: EHealthDataSource) {
        self.controller?.startLoadingAnimation()
        _EHProfileServices.updateEHProfile(ehProfile) { errorMessage, successMessage in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if successMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Success", comment: ""), message: successMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
        }
    }
}
