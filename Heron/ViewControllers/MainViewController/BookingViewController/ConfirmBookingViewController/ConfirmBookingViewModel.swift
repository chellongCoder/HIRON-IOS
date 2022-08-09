//
//  ConfirmBookingViewModel.swift
//  Heron
//
//  Created by Luu Luc on 08/08/2022.
//

import UIKit
import RxRelay

class ConfirmBookingViewModel: BaseViewModel {
    
    weak var controller     : ConfirmBookingViewController?
    var bookingProduct      = BehaviorRelay<ProductDataSource?>(value: nil)
    
    func getProductList() {
        
        guard let selectedDepartmentID = _BookingServices.selectedDepartment.value?.id else {return}
        
        let param : [String: Any] = ["filter[featureType][eq]" : "booking",
                                     "sort[createdAt]" : "desc",
                                     "filter[available][eq]":true,
                                     "filter[type][eq]":"simple",
                                     "filter[attributeValues][value][eq]":selectedDepartmentID]
        self.controller?.startLoadingAnimation()
        _InventoryServices.getListProducts(param: param) { errorMessage, listNewProducts in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let newProduct = listNewProducts?.first {
                self.bookingProduct.accept(newProduct)
            }
        }
    }
}
