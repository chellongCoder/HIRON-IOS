//
//  CartServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

import ObjectMapper
import RxSwift
import RxRelay

class CartServices {
    
    public static let sharedInstance = CartServices()
    var cartData            = BehaviorRelay<CartDataSource?>(value: nil)
    private let disposeBag  = DisposeBag()

    func checkout(cart: CartDataSource, completion:@escaping (String?, String?)-> Void) {
//        //NOTE: Define model
//        struct CartRequest: Codable {
//            let cartDetail: [CartDetailReq]
//            let couponIds: [String]?
//            let paymentMethod: String?
//        }
//
        //data mapping
        let cartDetail = cart.store.map{ CartDetailForCheckout(selectedCartItems: $0.cartItems.filter{$0.isSelected}.map{v in v.id}, targetId: $0.targetId, carrierCode: "grab")}.filter{$0.selectedCartItems?.count ?? 0 > 0}
      
        let fakeRecipient = Recipient(id: nil, createdAt: nil, updatedAt: nil, userId: nil, profileId: nil, firstName: "Presley", lastName: "Wilkinson", email: "frederick_dietrich71@gmail.com", phone: "0767595278", country: "MS", region: "Lake Aleenbury", province: "Honduras", district: "Goldner Forest", ward: "Lakin Mount", address: "754 Schimmel Extension", postalCode: "70000", latitude: 22.305, longitude: -20.4538, isDefault: nil)
        let cart = Cart(cartDetail: cartDetail, couponIds: [], recipient: fakeRecipient)
        let cartRequest = CartDetailReq(cart: cart, includes: "delivery", paymentMethodCode: "cards", paymentPlatform: "web_browser")
//        CartRequest(cartDetail: <#T##[CartDetailReq]#>, couponIds: <#T##[String]?#>, paymentMethod: <#T##String?#>)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(cartRequest),
            let output = String(data: data, encoding: .utf8)
            else { fatalError( "Error converting \(cartRequest) to JSON string") }
        print("JSON string = \(output)")
        
        let dictionary = try! DictionaryEncoder().encode(cartRequest)
        let fullURLRequest = kGatewayOrderURL + "/orders"
        
        _ = _AppDataHandler.post(parameters: dictionary as? [String : Any], fullURLRequest: fullURLRequest) { responseData in
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
                
        let fullURLRequest = kGatwayCartURL + String(format: "/carts/items/%ld", itemID)
        _ = _AppDataHandler.delete(parameters: nil, fullURLRequest: fullURLRequest, completion: { responseData in
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
                
                #warning("API_NEED_MAINTAIN")
                // API response array nhưng lại kẹp trong data.
                
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
