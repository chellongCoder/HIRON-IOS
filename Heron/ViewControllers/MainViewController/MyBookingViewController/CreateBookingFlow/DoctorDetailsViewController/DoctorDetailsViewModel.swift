//
//  DoctorDetailsViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import UIKit
import RxRelay

class DoctorDetailsViewModel: NSObject {
    weak var controller     : DoctorDetailsViewController?
    var doctorData          = BehaviorRelay<DoctorDataSource?>(value: nil)
    var doctorReviews       = BehaviorRelay<[ReviewDataSource]>(value: [])
    var relatedDoctors      = BehaviorRelay<[DoctorDataSource]>(value: [])
    
    override init() {
        super.init()
        
        doctorReviews.accept([ReviewDataSource.init(JSONString: "{}")!,
                              ReviewDataSource.init(JSONString: "{}")!])
    }
    
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
                let filteredDoctors = listDoctor.filter { newDoctorData in
                    return newDoctorData.id != self.doctorData.value?.id
                }
                self.relatedDoctors.accept(filteredDoctors)
            }
        }
    }
}
