//
//  HomepageViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 06/11/2022.
//

import Foundation
import RxRelay

class HomepageViewModel: BaseViewModel {
    weak var controller     : HomepageViewController?
    var listBanners         : [String] = ["banner_image1", "banner_image2", "banner_image3"]
    var filterData          : CategoryDataSource?
    var listProducts        = BehaviorRelay<[ProductDataSource]>(value: Array(_AppCoreData.listsavedProducts))
    
    func getProductList() {
        
        var param : [String: Any] = ["filter[featureType][eq]" : "ecom",
                                     "sort[media][sortOrder]": "asc",
                                     "sort[createdAt]" : "desc"]
        if let filterData = filterData {
            param = ["filter[featureType][eq]" : "ecom",
                     "filter[categoryId][eq]" : filterData.id,
                     "filter[quantity][not]" : "null",
                     "filter[visibility][eq]" : "true",
                     "sort[createdAt]" : "desc"]
        }
        
//        self.controller?.startLoadingAnimation()
        _InventoryServices.getListProducts(param: param) { errorMessage, listNewProducts in
//            self.controller?.endLoadingAnimation()
            self.controller?.refreshControl.endRefreshing()
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let listNewProducts = listNewProducts {
                self.listProducts.accept(listNewProducts)
            }
        }
    }
}