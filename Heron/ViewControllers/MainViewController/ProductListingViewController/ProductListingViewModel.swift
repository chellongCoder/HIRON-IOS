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
    
    func getProjectList()
    {
        self.controller?.startLoadingAnimation()
        _AppDataHandler.getListProducts { errorMessage, listNewProducts in
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
