//
//  ProductListingViewModel.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit
import RxSwift
import RxRelay

class ProductListingViewModel: NSObject {
    weak var controller     : ProductListingViewController?
    var listBanners         : [String] = ["", "", "", "", "", "", "", "", ""]
    var filterData          : CategoryDataSource?
    var listProducts        = BehaviorRelay<[ProductDataSource]>(value: [])
    
    func getProductList() {
        
        var param : [String: Any] = ["filter[featureType][eq]" : "ecom",
                                     "sort[createdAt]" : "desc"]
        if let filterData = filterData {
            param = ["filter[featureType][eq]" : "ecom",
                     "filter[categoryId][eq]" : filterData.id,
                     "filter[quantity][not]" : "null",
                     "filter[visibility][eq]" : "true",
                     "sort[createdAt]" : "desc"]
        }
        
        self.controller?.startLoadingAnimation()
        _InventoryServices.getListProducts(param: param) { errorMessage, listNewProducts in
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
            
            if let listNewProducts = listNewProducts {
                self.listProducts.accept(listNewProducts)
            }
        }
    }
    
    func reloadCart() {
        _CartServices.getCartDataSource { errorMessage in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
        }
    }
}
