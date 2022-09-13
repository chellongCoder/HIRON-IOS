//
//  CartServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

import ObjectMapper
import RxSwift
import RxRelay
import Foundation

class CartServices : NSObject {
    
    public static let sharedInstance = CartServices()
    var cartData                    = BehaviorRelay<CartDataSource?>(value: nil)
    var cartPreCheckoutResponseData = BehaviorRelay<CartPrepearedResponseDataSource?>(value: nil)
    var voucherCode                 = BehaviorRelay<VoucherDataSource?>(value: nil)
    private let disposeBag          = DisposeBag()

    override init() {
        super.init()
        
        self.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                if self.isCartEmptySelection() && self.voucherCode.value != nil {
                    self.voucherCode.accept(nil)
                    return
                }
                self.prepearedCheckout()
            }
            .disposed(by: disposeBag)
        
        self.voucherCode
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.prepearedCheckout()
            }
            .disposed(by: disposeBag)
    }
    
    func cleanData() {
        cartData.accept(nil)
    }
    
    private func cartUpdateFailed() {
        // disable all selected items
        self.cartData.accept(self.uncheckAll(cartData: self.cartData.value))
    }
    
    func prepearedCheckout() {
        guard let cartData = cartData.value else {
            cartPreCheckoutResponseData.accept(nil)
            return
        }
        
        var newCheckoutRequestDataSource = CartPrepearedRequestDataSource.init(JSONString: "{}", context: nil)!
        for store in cartData.store {
            var newCheckoutRequestCartDetail = CartPrepearedRequestCartDetail.init(JSONString: "{}", context: nil)!
            
            for cartItem in store.cartItems where cartItem.isSelected {
                newCheckoutRequestCartDetail.selectedCartItems.append(cartItem.id)
            }
            newCheckoutRequestCartDetail.targetId = store.targetId
            if !newCheckoutRequestCartDetail.selectedCartItems.isEmpty {
                newCheckoutRequestDataSource.cartDetail.append(newCheckoutRequestCartDetail)
            }
        }
        
        // check empty list
        if newCheckoutRequestDataSource.cartDetail.isEmpty {
            cartPreCheckoutResponseData.accept(nil)
            return
        }
        
        // Check Vouchers
        if let voucher = self.voucherCode.value {
            newCheckoutRequestDataSource.couponIds.append(voucher.id)
        }
        
        let fullURLRequest = kGatwayCartURL + "/carts/pre-checkout"
        _ = _AppDataHandler.post(parameters: newCheckoutRequestDataSource.toJSON(), fullURLRequest: fullURLRequest) { responseData in
            
            if responseData.responseCode == 400 && !(responseData.responseMessage ?? "").isEmpty {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                     message: responseData.responseMessage ?? "",
                                                     preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                self.cartUpdateFailed()
                return
            }
            
            if let data = responseData.responseData?["data"] as? [String:Any] {
                let cartPrecheckoutData = Mapper<CartPrepearedResponseDataSource>().map(JSON: data)
                if let cartPrecheckoutData = cartPrecheckoutData {
                    self.cartPreCheckoutResponseData.accept(cartPrecheckoutData)
                    return
                }
            }
        }
    }
    
    func addToCart(listProducts: [ProductDataSource], completion:@escaping (String?, String?) -> Void) {
        
        var productsDict : [[String:Any]] = []
        for product in listProducts {
            let productDict : [String: Any] = ["productId" : product.id,
                                               "quantity" : product.quantity]
            productsDict.append(productDict)
        }
        
        let param : [String:Any] = ["products" : productsDict]
        let fullURLRequest = kGatwayCartURL + "/carts/add-to-cart"
        
        _ = _AppDataHandler.post(parameters: param, fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 200, responseData.responseCode == 204 {
                completion(nil, responseData.responseMessage)
                return
            } else {
                completion(responseData.responseMessage, nil)
            }
        })
    }
    
    func removeCartItem(itemID: String, completion:@escaping (String?, String?) -> Void) {
                
        let fullURLRequest = kGatwayCartURL + String(format: "/carts/items/%@", itemID)
        _ = _AppDataHandler.delete(parameters: nil, fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 200, responseData.responseCode == 204 {
                completion(nil, responseData.responseMessage)
                return
            } else {
                completion(responseData.responseMessage, nil)
            }
        })
    }
    
    func updateCartItemQuanlity(itemID: String, newValue: Int, completion:@escaping (String?, String?) -> Void) {
                
        let fullURLRequest = kGatwayCartURL + String(format: "/carts/items/%@", itemID)
        let params : [String: Any] = ["quantity": newValue]
        _ = _AppDataHandler.patch(parameters: params, fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 200, responseData.responseCode == 204 {
                completion(nil, responseData.responseMessage)
                return
            } else {
                completion(responseData.responseMessage, nil)
            }
        })
    }
    
    func getCartDataSource(completion:@escaping (String?) -> Void) {
        
        let fullURLRequest = kGatwayCartURL + "/carts"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest, completion: { responseData in
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage)
                return
            } else {                
                if let data = responseData.responseData?["data"] as? [String:Any] {
                    completion(nil)
                    if var newCartData = Mapper<CartDataSource>().map(JSON: data) {
                        if let oldCartData = self.cartData.value {
                            newCartData = self.matchingCheckoutSelectedOfStore(newCartData, oldCartData: oldCartData)
                        }
                        
                        self.cartData.accept(newCartData)
                    }
                }
            }
        })
    }
    
    private func matchingCheckoutSelectedOfStore(_ newCartData: CartDataSource, oldCartData: CartDataSource) -> CartDataSource {
        var returnCartData = newCartData
        for (storeIndex, storeData) in newCartData.store.enumerated() {
            if let match = oldCartData.store.first( where: {storeData.id == $0.id }) {
                returnCartData.store[storeIndex] = self.matchingCheckoutSelectedOfItem(returnCartData.store[storeIndex], oldStore: match)
                returnCartData.store[storeIndex].isCheckoutSelected = match.isCheckoutSelected
            }
        }
        
        return returnCartData
    }
    
    private func uncheckAll(cartData: CartDataSource?) -> CartDataSource? {
        
        guard let cartData = cartData else {
            return nil
        }

        var newStore : [StoreDataSource] = []
        for var store in cartData.store {
            
            store.isCheckoutSelected = false
            var newItems : [CartItemDataSource] = []
            for var item in store.cartItems {
                item.isSelected = false
                newItems.append(item)
            }
            store.cartItems = newItems
            newStore.append(store)
        }
        
        var newCart = cartData
        newCart.store = newStore
        return newCart
    }
    
    private func matchingCheckoutSelectedOfItem(_ newStore: StoreDataSource, oldStore: StoreDataSource) -> StoreDataSource {
        var returnStore = newStore
        for (itemIndex, itemData) in newStore.cartItems.enumerated() {
            if let match = oldStore.cartItems.first( where: { itemData.id == $0.id }) {
                returnStore.cartItems[itemIndex].isSelected = match.isSelected
            }
        }
        
        return returnStore
    }
    
    func isCartEmptySelection() -> Bool {
        for store in self.cartData.value?.store ?? [] {
            for cartItem in store.cartItems where cartItem.isSelected {
                return false
            }
        }
        
        return true
    }
}
