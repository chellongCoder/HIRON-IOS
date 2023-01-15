//
//  SelectDateAndTimeBookingViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import UIKit
import RxRelay
import RxSwift

class SelectDateAndTimeBookingViewModel: NSObject {
    weak var controller         : SelectDateAndTimeBookingViewController?
    private var listTimeables   : [TimeableDataSource] = []
    let showedlistTimeables     = BehaviorRelay<[TimeableDataSource]>(value: [])
    var selectedDate            : Date?
    let selectedType            = BehaviorRelay<TimeableBlockType>(value: .morning)
    
    private let disposeBag      = DisposeBag()
    
    override init() {
        super.init()
        
        self.selectedType
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.processBlockData()
            }
            .disposed(by: disposeBag)
    }
    
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
                self.listTimeables = listTimeables.filter { timeableData in
                    return( timeableData.totalSlots - timeableData.totalUsage >= 1)
                }
                
                self.processBlockData()
            }
        }
    }
    
    // MARK: - Untils
    func processBlockData() {
        self.showedlistTimeables.accept(
            self.listTimeables.filter { timeableData in
                return (timeableData.blockType == self.selectedType.value)
        })
    }
    
    // CollectionView
    func getListTimeableByDate() -> [TimeableDataSource] {
        if self.showedlistTimeables.value.isEmpty {
            return []
        }
        let selectedDate = selectedDate ?? Date()
        let dateString = selectedDate.toString(dateFormat: "MMM dd, yyyy")
        
        let listFiltered = self.showedlistTimeables.value.filter { timeableData in
            let date = Date.init(timeIntervalSince1970: TimeInterval(timeableData.startTime/1000))
            let currentDateInt = Int(Date().timeIntervalSince1970*1000)
            return (date.toString(dateFormat: "MMM dd, yyyy") == dateString) && (timeableData.startTime >= (currentDateInt + 10000)) && timeableData.blockType == selectedType.value
        }
        
        return listFiltered
    }
    
    // Calendar
    func getListTimeableByDate(_ date: Date) -> [TimeableDataSource] {
        if self.listTimeables.isEmpty { return [] }
        let dateString = date.toString(dateFormat: "MMM dd, yyyy")
        
        let listFiltered = self.listTimeables.filter { timeableData in
            let date = Date.init(timeIntervalSince1970: TimeInterval(timeableData.startTime/1000))
            let currentDateInt = Int(Date().timeIntervalSince1970*1000)
            return (date.toString(dateFormat: "MMM dd, yyyy") == dateString) && (timeableData.startTime >= (currentDateInt + 10000))
        }
        
        return listFiltered
    }
}
