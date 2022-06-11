//
//  CartViewModel.swift
//  Heron
//
//  Created by Luu Luc on 15/05/2022.
//

import UIKit

class CartViewModel: NSObject {
    weak var controller     : CartViewController? = nil
    var cartDataSource      : CartDataSource? = nil
    
    func addToCart(product: ProductDataSource, quantity: Int? = 1) {
        self.controller?.startLoadingAnimation()
        _CartServices.addToCart(listProducts: [product]) { errorMessage, successMessage in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            self.reloadCart()
        }
    }
    
    func removeItemFromCart(_ item: CartItemDataSource) {
        
//        guard let productID = item.product?.id else {return}
        
        self.controller?.startLoadingAnimation()
        _CartServices.removeCartItem(itemID: item.id) { errorMessage, successMessage in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            self.reloadCart()
        }
    }
    
    func updateCartItemsQuanlity(_ item: CartItemDataSource, newValue: Int) {
                
        self.controller?.startLoadingAnimation()
        _CartServices.updateCartItemQuanlity(itemID: item.id, newValue: newValue) { errorMessage, successMessage in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            self.reloadCart()
        }
    }
    
    func reloadCart() {
        self.controller?.startLoadingAnimation()
        
        _CartServices.getCartDataSource { errorMessage, cartData in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
//            if let cartData = cartData {
//                DispatchQueue.main.async {
//                    self.cartDataSource = cartData
//                    self.controller?.tableView.reloadData()
//                }
//            }
        }
    }
}
