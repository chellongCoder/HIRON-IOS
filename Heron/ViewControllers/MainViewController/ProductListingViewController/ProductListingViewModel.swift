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
    weak var controller     : ProductListingViewController? = nil
    var listBanners         : [String] = ["","","","","","","","",""]
    var filterData          : CategoryDataSource? = nil
    var listProducts        = BehaviorRelay<[ProductDataSource]>(value: [])
    
    func getProductList()
    {
        
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
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
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
        _CartServices.getCartDataSource { errorMessage, cartData in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
        }
    }
}
