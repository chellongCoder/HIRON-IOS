//
//  CartServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

import ObjectMapper
import RxSwift
import RxRelay

class CartServices : NSObject {
    
    public static let sharedInstance = CartServices()
    var cartData                    = BehaviorRelay<CartDataSource?>(value: nil)
    var cartPreCheckoutResponseData = BehaviorRelay<CartPrepearedResponseDataSource?>(value: nil)
    var deliveryAddress             = BehaviorRelay<ContactDataSource?>(value: nil)
    var billingAddress              = BehaviorRelay<ContactDataSource?>(value: nil)
    var voucherCode                 = BehaviorRelay<VoucherDataSource?>(value: nil)
    private let disposeBag          = DisposeBag()

    override init() {
        super.init()
        
        self.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                self.prepearedCheckout()
            }
            .disposed(by: disposeBag)
        
        self.deliveryAddress
            .observe(on: MainScheduler.instance)
            .subscribe { contactDataSource in
                self.prepearedCheckout()
            }
            .disposed(by: disposeBag)
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
        
        //
        var fullURLRequest = kGatwayCartURL + "/carts/pre-checkout"
        
        // Check shipping address / receipt
        if let shippingAddess = self.deliveryAddress.value {
            fullURLRequest = kGatwayCartURL + "/carts/pre-checkout?includes=delivery"
            newCheckoutRequestDataSource.recipient = CartPrepearedRequestReceipt.init(JSONString: "{}", context: nil)!
            newCheckoutRequestDataSource.recipient?.firstName = shippingAddess.firstName
            newCheckoutRequestDataSource.recipient?.lastName = shippingAddess.lastName
            newCheckoutRequestDataSource.recipient?.email = shippingAddess.email
            newCheckoutRequestDataSource.recipient?.phone = shippingAddess.phone
            newCheckoutRequestDataSource.recipient?.address = shippingAddess.address
            newCheckoutRequestDataSource.recipient?.province = shippingAddess.province
            newCheckoutRequestDataSource.recipient?.country = shippingAddess.country
            newCheckoutRequestDataSource.recipient?.postalCode = shippingAddess.postalCode
            newCheckoutRequestDataSource.recipient?.latitude = shippingAddess.latitude
            newCheckoutRequestDataSource.recipient?.longitude = shippingAddess.longitude
            newCheckoutRequestDataSource.recipient?.isDefault = shippingAddess.isDefault
        }
        
        _ = _AppDataHandler.post(parameters: newCheckoutRequestDataSource.toJSON(), fullURLRequest: fullURLRequest) { responseData in
            if let data = responseData.responseData?["data"] as? [String:Any] {
                let cartPrecheckoutData = Mapper<CartPrepearedResponseDataSource>().map(JSON: data)
                if let cartPrecheckoutData = cartPrecheckoutData {
                    self.cartPreCheckoutResponseData.accept(cartPrecheckoutData)
                }
            }
        }
    }
    
    func addToCart(listProducts: [ProductDataSource], completion:@escaping (String?, String?)-> Void) {
        
        var productsDict : [[String:Any]] = []
        for product in listProducts {
            let productDict : [String: Any] = ["productId" : product.id,
                                               "quantity" : product.quantity]
            productsDict.append(productDict)
        }
        
        let param : [String:Any] = ["products" : productsDict]
        let fullURLRequest = kGatwayCartURL + "/carts/add-to-cart"
        
        _ = _AppDataHandler.post(parameters: param, fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            }
            else if responseData.responseCode == 200, responseData.responseCode == 204 {
                completion(nil, responseData.responseMessage)
            }
            else {
                completion(responseData.responseMessage, nil)
            }
        })
    }
    
    func removeCartItem(itemID: String, completion:@escaping (String?, String?)-> Void) {
                
        let fullURLRequest = kGatwayCartURL + String(format: "/carts/items/%@", itemID)
        _ = _AppDataHandler.delete(parameters: nil, fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode == 200 || responseData.responseCode == 204 {
                completion(nil, responseData.responseMessage)
            }
            else {
                completion(responseData.responseMessage, nil)
            }
        })
    }
    
    func updateCartItemQuanlity(itemID: String, newValue: Int, completion:@escaping (String?, String?)-> Void) {
                
        let fullURLRequest = kGatwayCartURL + String(format: "/carts/items/%@", itemID)
        let params : [String: Any] = ["quantity": newValue]
        _ = _AppDataHandler.patch(parameters: params, fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode == 200 || responseData.responseCode == 204 {
                completion(nil, responseData.responseMessage)
            }
            else {
                completion(responseData.responseMessage, nil)
            }
        })
    }
    
    func getCartDataSource(completion:@escaping (String?, CartDataSource?)-> Void) {
        
        let fullURLRequest = kGatwayCartURL + "/carts"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {                
                if let data = responseData.responseData?["data"] as? [String:Any] {
                    completion(responseData.responseMessage, Mapper<CartDataSource>().map(JSON: data))
                    if let cartData = Mapper<CartDataSource>().map(JSON: data) {
                        self.cartData.accept(cartData)
                    }
                }
            }
        })
    }
}
