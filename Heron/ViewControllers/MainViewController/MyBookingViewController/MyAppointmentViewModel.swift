//
//  MyApoitmentViewModel.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit
import RxRelay
import RxSwift

class MyAppointmentViewModel: NSObject {
    weak var controller : MyBookingsViewController?
    public let filter               = BehaviorRelay<String>(value:"pending")
    public let listAppoitments      = BehaviorRelay<[BookingAppointmentDataSource]>(value: [])
    
    private let disposeBag          = DisposeBag()
    
    override init() {
        super.init()
        self.filter
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.getMyAppointments()
            }
            .disposed(by: disposeBag)
    }
    
    private func getMyAppointments() {
        self.controller?.startLoadingAnimation()
        _BookingServices.getListAppointments(filter.value) { errorMessage, listAppointments in
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
            
            if let data = listAppointments {
                self.listAppoitments.accept(data)
            }
        }
    }
}
