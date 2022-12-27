//
//  CartViewModel.swift
//  Heron
//
//  Created by Luu Luc on 15/05/2022.
//

import UIKit
import RxRelay

class CartViewModel {
    weak var controller     : CartViewController?
    var cartDataSource      : CartDataSource?
    
    func addToCart(product: ProductDataSource, quantity: Int? = 1) {
        self.controller?.startLoadingAnimation()
        _CartServices.addToCart(listProducts: [product]) { errorMessage, _ in
            self.controller?.endLoadingAnimation()
            var alertVC: UIAlertController!
            if errorMessage != nil {
                alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
            } else {
                alertVC = UIAlertController.init(title: NSLocalizedString("Add to cart successful!", comment: ""),
                                                     message: "Check in the cart to view your selected product", preferredStyle: .alert)
            }
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)

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
                _CartServices.reloadCart()
                return
            }
        }
    }
    
    func selectAnotherItem(_ item: CartItemDataSource) {
        if let productData = item.product {
            
            _InventoryServices.getProductDetails(productID: productData.id) { _, newProductData in
                if let newProductData = newProductData {
                    let addToCartVC = AddToCartViewController(productData: newProductData)
                    addToCartVC.modalPresentationStyle = .overFullScreen
                    self.controller?.present(addToCartVC, animated: true)
                }
            }
        }
    }
}
