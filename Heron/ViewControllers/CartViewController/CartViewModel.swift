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
    
    func checkout() {
        self.controller?.startLoadingAnimation()
        assert(cartDataSource != nil, "Cart empty")
        _AppDataHandler.checkout(cart: self.cartDataSource!) { errorMessage, successMessage in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            //TODO: Clear cart
            self.reloadCart()
        }
        
    }
    
    func addToCart(product: ProductDataSource, quantity: Int? = 1) {
        self.controller?.startLoadingAnimation()
        _AppDataHandler.addToCart(listProducts: [product]) { errorMessage, successMessage in
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
        self.controller?.startLoadingAnimation()
        _AppDataHandler.removeCartItem(itemID: item.id) { errorMessage, successMessage in
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
        
        _AppDataHandler.getCartDataSource(completion: { errorMessage, cartData in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let cartData = cartData {
                DispatchQueue.main.async {
                    self.cartDataSource = cartData
                    self.controller?.tableView.reloadData()
                }
            }
        })
    }
}
