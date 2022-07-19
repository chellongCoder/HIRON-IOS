//
//  ProductDetailsViewModel.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit
import RxCocoa
import RxSwift

class ProductDetailsViewModel: NSObject {
    weak var controller : ProductDetailsViewController?
    var productDataSource   = BehaviorRelay<ProductDataSource?>(value: nil)
    
    func reloadProductDetails() {
//        guard let productDataSource = productDataSource.value else {
//            return
//        }

        _InventoryServices.getProductDetails(productID: "9464f4d7-2ee4-4a66-9176-5a2e017ae551") { errorMessage, newProductDetails in
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
