//
//  ProductListingViewModel.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit
import RxSwift
import RxRelay

enum ProductListingMode {
    case gridView
    case listView
}

class ProductListingViewModel: NSObject {
    weak var controller     : ProductListingViewController?
    var listBanners         : [String] = ["banner_image1", "banner_image2", "banner_image3"]
    var filterData          : CategoryDataSource?
    let listProducts        = BehaviorRelay<[ProductDataSource]>(value: Array(_AppCoreData.listsavedProducts))
    let viewMode            = BehaviorRelay<ProductListingMode>(value: .gridView)
    
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
        
        if self.listProducts.value.isEmpty {
            self.controller?.startLoadingAnimation()
        }
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
}
