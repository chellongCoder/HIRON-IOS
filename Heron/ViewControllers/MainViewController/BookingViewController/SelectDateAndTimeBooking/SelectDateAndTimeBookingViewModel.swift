//
//  SelectDateAndTimeBookingViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import UIKit
import RxRelay

class SelectDateAndTimeBookingViewModel: NSObject {
    weak var controller     : SelectDateAndTimeBookingViewController?
    var listTimeables       = BehaviorRelay<[TimeableDataSource]>(value: [])
    var selectedDate        : Date?
    
    func getListTimeable() {
        self.controller?.startLoadingAnimation()
        _BookingServices.getListTimeables { errorMessage, listTimeables in
            self.controller?.endLoadingAnimation()
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let listTimeables = listTimeables {
                self.listTimeables.accept(listTimeables)
            }
        }
    }
    
    // MARK: - Untils
    func getListTimeableByDate() -> [TimeableDataSource] {
        if self.listTimeables.value.count == 0 {
            return []
        }
        let selectedDate = selectedDate ?? Date()
        let dateString = selectedDate.toString(dateFormat: "dd-MM-yyyy")
        
        let listFiltered = self.listTimeables.value.filter { timeableData in
            let date = Date.init(timeIntervalSince1970: TimeInterval(timeableData.startTime/1000))
            return date.toString(dateFormat: "dd-MM-yyyy") == dateString
        }
        
        return listFiltered
    }
    
    func getListTimeableByDate(_ date: Date) -> [TimeableDataSource] {
        if self.listTimeables.value.count == 0 { return [] }
        let dateString = date.toString(dateFormat: "dd-MM-yyyy")
        
        let listFiltered = self.listTimeables.value.filter { timeableData in
            let date = Date.init(timeIntervalSince1970: TimeInterval(timeableData.startTime/1000))
            return date.toString(dateFormat: "dd-MM-yyyy") == dateString
        }
        
        return listFiltered
    }
}
