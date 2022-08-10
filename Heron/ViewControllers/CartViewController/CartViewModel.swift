//
//  CartViewModel.swift
//  Heron
//
//  Created by Luu Luc on 15/05/2022.
//

import UIKit

class CartViewModel {
    weak var controller     : CartViewController?
    var cartDataSource      : CartDataSource?
    
    func addToCart(product: ProductDataSource, quantity: Int? = 1) {
        self.controller?.startLoadingAnimation()
        _CartServices.addToCart(listProducts: [product]) { errorMessage, _ in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
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
        _CartServices.removeCartItem(itemID: item.id) { errorMessage, _ in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
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
        _CartServices.updateCartItemQuanlity(itemID: item.id, newValue: newValue) { errorMessage, _ in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            self.reloadCart()
        }
    }
    
    func reloadCart() {
        
        if _CartServices.cartPreCheckoutResponseData.value != nil {
            return
        }
        
        self.controller?.startLoadingAnimation()
        
        _CartServices.getCartDataSource { errorMessage, _ in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
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
