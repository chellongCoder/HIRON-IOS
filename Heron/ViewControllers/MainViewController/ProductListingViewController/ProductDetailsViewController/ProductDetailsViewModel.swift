//
//  ProductDetailsViewModel.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class ProductDetailsViewModel: NSObject {
    weak var controller : ProductDetailsViewController?
    var productDataSource   = BehaviorRelay<ProductDataSource?>(value: nil)
    var filterData          : CategoryDataSource?
    let listProducts        = BehaviorRelay<[ProductDataSource]>(value: [ProductDataSource]([]))
    let viewMode            = BehaviorRelay<ProductListingMode>(value: .gridView)

    func getProductList(_ productId: String) {
        
        let param : [String: Any] = ["filter[featureType][eq]" : "ecom",
                                     "filter[categoryId][eq]" : "eabf1a86-a1c0-49b7-a986-40934010af10",
                                     "sort[createdAt]" : "desc"]
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
    
    func reloadProductDetails() {
        guard let productDataSource = productDataSource.value else {
            return
        }

        self.controller?.startLoadingAnimation()
        _InventoryServices.getProductDetails(productID: productDataSource.id) { errorMessage, newProductDetails in
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

            if let newProductDetails = newProductDetails {
                self.productDataSource.accept(newProductDetails)
            }
        }
    }
}
