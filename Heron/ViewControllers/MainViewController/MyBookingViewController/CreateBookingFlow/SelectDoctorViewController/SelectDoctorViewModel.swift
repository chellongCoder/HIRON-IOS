//
//  SelectDoctorViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxRelay

class SelectDoctorViewModel: NSObject {
    weak var controller     : SelectDoctorViewController?
    var listDoctor          = BehaviorRelay<[DoctorDataSource]>(value: [])
    
    func getListDoctor() {
        self.controller?.startLoadingAnimation()
        _BookingServices.getListDoctors { errorMessage, listDoctor in
            self.controller?.endLoadingAnimation()
            self.controller?.refreshControl.endRefreshing()
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let listDoctor = listDoctor {
                self.listDoctor.accept(listDoctor)
                
                // Auto select frist doctor
                if !listDoctor.isEmpty {
                    _BookingServices.selectedDoctor.accept(listDoctor[0])
                }
            }
        }
    }
}
