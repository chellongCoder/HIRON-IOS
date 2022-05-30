//
//  ProductFilterViewModel.swift
//  Heron
//
//  Created by Luu Luc on 14/05/2022.
//

import UIKit

class ProductFilterViewModel: NSObject {
    weak var controller : ProductFilterViewController? = nil
    var listCategories  : [CategoryDataSource] = []
    
    func getListCategoris() {
        controller?.startLoadingAnimation()
        _InventoryServices.getListCategories { errorMessage , listNewCategories in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let listNewCategories = listNewCategories {
                self.listCategories = listNewCategories
                self.controller?.collectionview.reloadData()
            }
        }
    }
}
