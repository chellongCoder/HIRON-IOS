//
//  ProductListingViewModel.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit

class ProductListingViewModel: NSObject {
    weak var controller     : ProductListingViewController? = nil
    var listProducts        : [ProductDataSource] = []
    var listBanners         : [String] = ["","","","","","","","",""]
    var filterData          : CategoryDataSource? = nil
    
    func getProjectList()
    {
        
        var param : [String: Any] = ["filter[featureType][eq]" : "ecom",
                                     "sort[createdAt]" : "desc"]
        if let filterData = filterData {
            param = ["filter[featureType][eq]" : "ecom",
                     "filter[categoryId][eq]" : filterData.id,
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
                self.listProducts = listNewProducts
                self.controller?.tableView.reloadData()
            }
        }
    }
}
