//
//  SelectSpecialtyViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxRelay

class SelectDepartmentViewModel: NSObject {
    weak var controller     : SelectDepartmentViewController?
    var listDepartments     = BehaviorRelay<[TeamDataSource]>(value: [])
    
    func getListDepartments() {
        self.controller?.startLoadingAnimation()
        _BookingServices.getListDepartments { errorMessage, listDepartments in
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
            
            if let listDepartments = listDepartments {
                self.listDepartments.accept(listDepartments)
                
                // Auto select frist doctor
                if !listDepartments.isEmpty {
                    _BookingServices.selectedDepartment.accept(listDepartments[0])
                }
            }
        }
    }
    
    func getBackgroundColor(_ index: Int) -> UIColor {
        let sourceColor = ["fdefda", "eefbfb", "ebedfa", "fbedf9", "fff0f0", "e6faf5", "fbf5d8", "fff0e6"]
        
        let countedIndex = index % sourceColor.count
        return UIColor.init(hexString: sourceColor[countedIndex])!
    }
}
