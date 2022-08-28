//
//  CheckoutServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

import RxRelay
import RxSwift
import ObjectMapper

class CheckoutServices: NSObject {
    public static let sharedInstance = CheckoutServices()
    
    var deliveryAddress             = BehaviorRelay<ContactDataSource?>(value: nil)
    var billingAddress              = BehaviorRelay<UserDataSource?>(value: nil)
    var cartPreCheckoutResponseData = BehaviorRelay<CartPrepearedResponseDataSource?>(value: nil)
    private let disposeBag          = DisposeBag()
    
    override init() {
        super.init()
        self.deliveryAddress
            .observe(on: MainScheduler.instance)
            .subscribe{ _ in
                self.prepearedCheckout()
            }
            .disposed(by: disposeBag)
        
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.prepearedCheckout()
            }
            .disposed(by: disposeBag)
        
        _CartServices.voucherCode
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.prepearedCheckout()
            }
            .disposed(by: disposeBag)
    }
    
    func prepearedCheckout() {
        guard let cartData = _CartServices.cartData.value else {
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
        if let voucher = _CartServices.voucherCode.value {
            newCheckoutRequestDataSource.couponIds.append(voucher.id)
        }
        
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
    
    func createOrder(completion:@escaping (String?, String?) -> Void) {
        guard let cartData = _CartServices.cartData.value else {
            completion("Cart is empty", nil)
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
            completion("Selected list is empty", nil)
            return
        }
        
        // Check Vouchers
        if let voucher = _CartServices.voucherCode.value {
            newCheckoutRequestDataSource.couponIds.append(voucher.id)
        }
        
        // Check shipping address / receipt
        if let shippingAddess = self.deliveryAddress.value {
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
        
        let params : [String: Any] = ["cart" : newCheckoutRequestDataSource.toJSON(),
                                      "includes":"delivery",
                                      "paymentMethodCode":"cards",
                                      "paymentPlatform":"web_browser"]
        let fullURLRequest = kGatewayOrderURL + "/orders"
        
        _ = _AppDataHandler.post(parameters: params, fullURLRequest: fullURLRequest) { responseData in
            if responseData.responseCode == 200 {
                completion(nil, responseData.responseMessage)
            } else {
                completion(responseData.responseMessage, nil)
            }
        }
    }
    
    // MARK: - HARD CODE
    func forceCheckoutSubscriptionPlan(_ transactionID: String,
                                       completion:@escaping (String?, String?) -> Void) {
        let fullURLRequest = kGatewayPaymentURL + "/payments/confirm/" + transactionID
        
        _ = _AppDataHandler.post(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
            if responseData.responseCode == 200 {
                completion(nil, responseData.responseMessage)
            } else {
                completion(responseData.responseMessage, nil)
            }
        }
    }
}
