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
    
    func getProductList() {
        
        guard let selectedDepartmentID = _BookingServices.selectedDepartment.value?.departmentID else {return}
        
        let param : [String: Any] = ["filter[featureType][eq]" : "booking",
                                     "sort[createdAt]" : "desc",
                                     "filter[available][eq]":true,
                                     "filter[type][eq]":"simple",
                                     "eavFilter[department_id][eq]":selectedDepartmentID]
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
                _BookingServices.bookingProduct.accept(newProduct)
            }
        }
    }
    
    func booking() {
        self.controller?.startLoadingAnimation()
        _BookingServices.createBookingOrder { errorMessage, clientSecret in
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                self.controller?.endLoadingAnimation()
                return
            }
            
            if let clientSecret = clientSecret {
                
                guard let controller = self.controller else { return }

                _PaymentServices.payment(clientSecret, fromViewController: controller) { paymentResult in
                    self.controller?.endLoadingAnimation()
                    
                    switch paymentResult {
                    case .completed:
                        let bookingSuccessVC = BookingSuccessViewController()
                        self.controller?.navigationController?.pushViewController(bookingSuccessVC, animated: true)
                    case .canceled:
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Cancelled", comment: ""),
                                                             message: "You has cancelled booking", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                            
                            self.controller?.navigationController?.popToRootViewController(animated: true)
                        }))
                        _NavController.showAlert(alertVC)
                    case .failed(let error):
                        let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                             message: error.localizedDescription ,
                                                             preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                            alertVC.dismiss()
                        }))
                        _NavController.showAlert(alertVC)
                    }
                }
                
                return
            }
            
            self.controller?.endLoadingAnimation()
            _NavController.gotoHomepage()
        }
    }
}