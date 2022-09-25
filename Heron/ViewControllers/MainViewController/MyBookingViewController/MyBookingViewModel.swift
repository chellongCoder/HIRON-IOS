//
//  MyApoitmentViewModel.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit
import RxRelay
import RxSwift

class MyBookingViewModel: NSObject {
    weak var controller : MyBookingsViewController?
    public let filter               = BehaviorRelay<String?>(value:nil)
    public let listBookings         = BehaviorRelay<[BookingAppointmentDataSource]>(value: [])
    
    private let disposeBag          = DisposeBag()
    
    override init() {
        super.init()
        self.filter
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.getMyBookings()
            }
            .disposed(by: disposeBag)
    }
    
    private func getMyBookings() {
        self.controller?.startLoadingAnimation()
        var param : [String:Any] = ["sort[createdAt" : "desc"]
        
        if let filter = self.filter.value {
            param["filter[status][eq]"] = filter
        }
        _BookingServices.getListBookings(param) { errorMessage, listBookings in
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
            
            if let data = listBookings {
                self.listBookings.accept(data)
            }
        }
    }
}
