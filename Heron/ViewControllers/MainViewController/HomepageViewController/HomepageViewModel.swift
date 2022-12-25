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
    var listBanners         : [String] = ["banner_image1", "banner_image2", "banner_image3", "banner_image1", "banner_image2", "banner_image3"]
    var listCategories      = BehaviorRelay<[CategoryDataSource]>(value: [])
    var categoryUICodes     : [CategoryUIData] = []
    #warning("HARD_CODE")
    var listBrands          = BehaviorRelay<[String]>(value: ["brand_1", "brand_2", "brand_3", "brand_1", "brand_2", "brand_3", "brand_1", "brand_2", "brand_3"])
    var filterData          : CategoryDataSource?
    var listFeatureProducts     = BehaviorRelay<[ProductDataSource]>(value: Array(_AppCoreData.listsavedProducts))
    var listSuggestedProducts   = BehaviorRelay<[ProductDataSource]>(value: Array(_AppCoreData.listsavedProducts))
    
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
    
    func getUICodeByIndex(_ index: Int) -> CategoryUIData {
        let countedIndex = index % categoryUICodes.count
        
        return categoryUICodes[countedIndex]
    }
    
    func getMoreUICode(_ row: Int) -> CategoryUIData {
        var code = self.getUICodeByIndex(8*row)
        code.imageName = "more"
        return code
    }
    
    func getFeatureProductList() {
        
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
                self.listFeatureProducts.accept(listNewProducts)
            }
        }
    }
    
    func getSuggestedProductList() {
        
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
                self.listSuggestedProducts.accept(listNewProducts)
            }
        }
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
                self.listCategories.accept(listNewCategories)
            }
        }
    }
}
