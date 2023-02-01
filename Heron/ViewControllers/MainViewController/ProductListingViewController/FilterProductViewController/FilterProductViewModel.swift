//
//  FilterProductViewModel.swift
//  Heron
//
//  Created by Bom on 1/31/23.
//

import Foundation
import RxRelay

class FilterProductViewModel: NSObject {
    weak var controller     : FilterProductViewController?
//    var listBanners         : [String] = ["banner_image1", "banner_image2", "banner_image3"]
//    var filterData          : CategoryDataSource?
//    let listProducts        = BehaviorRelay<[ProductDataSource]>(value: Array(_AppCoreData.listsavedProducts))
//    let viewMode            = BehaviorRelay<ProductListingMode>(value: .gridView)
    var listCategories      = BehaviorRelay<[CategoryDataSource]>(value: [])
    func getListCategories() {
        controller?.startLoadingAnimation()
        _InventoryServices.getListCategories { errorMessage, listNewCategories in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let listNewCategories = listNewCategories {
                self.listCategories.accept(listNewCategories)
                self.controller?.dropdown.menu.dataSource = listNewCategories.map {
                    $0.name
                }
            }
        }
    }
}
