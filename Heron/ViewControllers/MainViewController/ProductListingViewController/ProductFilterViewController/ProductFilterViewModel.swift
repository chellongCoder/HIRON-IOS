//
//  ProductFilterViewModel.swift
//  Heron
//
//  Created by Luu Luc on 14/05/2022.
//

import UIKit

struct CategoryUIData {
    var imageName: String
    var backgroundColorCode: String
    var textColorCode: String
}

class ProductFilterViewModel: NSObject {
    weak var controller : ProductFilterViewController?
    var listCategories  : [CategoryDataSource] = []
    
    var categoryUICodes : [CategoryUIData] = []
    
    override init() {
        super.init()
        
        #warning("HARD_CODE")
        categoryUICodes.append(CategoryUIData(imageName: "huyet_hoc", backgroundColorCode: "fdefd9", textColorCode: "f09400"))
        categoryUICodes.append(CategoryUIData(imageName: "thai_san", backgroundColorCode: "eefbfb", textColorCode: "14c1c2"))
        categoryUICodes.append(CategoryUIData(imageName: "thuoc_nuoc", backgroundColorCode: "fbedf9", textColorCode: "e385da"))
        categoryUICodes.append(CategoryUIData(imageName: "my_pham", backgroundColorCode: "ebedfb", textColorCode: "6276e0"))
        categoryUICodes.append(CategoryUIData(imageName: "thuoc_vien", backgroundColorCode: "fff0f0", textColorCode: "ff6d6f"))
        categoryUICodes.append(CategoryUIData(imageName: "tu_thuoc", backgroundColorCode: "dff4ff", textColorCode: "29b6ff"))
        categoryUICodes.append(CategoryUIData(imageName: "tpcn", backgroundColorCode: "eccd3533", textColorCode: "e3c42a"))
        categoryUICodes.append(CategoryUIData(imageName: "cancer", backgroundColorCode: "e5faf4", textColorCode: "05d197"))
        categoryUICodes.append(CategoryUIData(imageName: "antibio", backgroundColorCode: "fff0e6", textColorCode: "ff6d00"))
    }
    
    func getListCategoris() {
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
                self.listCategories = listNewCategories
                self.controller?.collectionview.reloadData()
            }
        }
    }
    
    func getUICodeByIndex(_ index: Int) -> CategoryUIData {
        let countedIndex = index % categoryUICodes.count
        
        return categoryUICodes[countedIndex]
    }
}
