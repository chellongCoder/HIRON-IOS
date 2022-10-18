//
//  BookingDetailViewModel.swift
//  Heron
//
//  Created by Luu Luc on 09/09/2022.
//

import UIKit
import RxRelay

class BookingDetailViewModel: NSObject {
    weak var controller     : BookingDetailViewController?
    let bookingData         = BehaviorRelay<BookingAppointmentDataSource?>(value:nil)
    let doctorData          = BehaviorRelay<DoctorDataSource?>(value:nil)
    
    func getDoctorData() {
        
        guard let doctorID = bookingData.value?.hostId else {return}
        
        self.controller?.startLoadingAnimation()
        _BookingServices.getDoctorDetailByID(doctorID) { errorMessage, doctorData in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                                     style: .default,
                                                     handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            self.doctorData.accept(doctorData)
        }
    }
}
