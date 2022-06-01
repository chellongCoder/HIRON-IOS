//
//  CartItemDataSource.swift
//  Heron
//
//  Created by Luu Luc on 19/05/2022.
//

import UIKit
import ObjectMapper

struct CartDataSource : Mappable {
    
    var subtotal    : Int = 0
    var grandTotal  : Int = 0
    var totalSaved  : Int = 0
    var totalItemCount  : Int = 0
    var totalQuantity   : Int = 0
    var store           : [StoreDataSource] = []  //same as cartDetails - rename for clean flow
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        subtotal    <- map["subtotal"]
        grandTotal  <- map["grandTotal"]
        totalSaved  <- map["totalSaved"]
        totalItemCount  <- map["totalItemCount"]
        totalQuantity   <- map["totalQuantity"]
        store           <- map["cartDetail"]
        
        subtotal = subtotal/100
        grandTotal = grandTotal/100
    }
}

struct StoreDataSource : Mappable {
    
    var id              : String = ""
    var storeDetails    : StoreDetailsDataSource? = nil
    var targetId        : String = ""
    var cartItems       : [CartItemDataSource] = []
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        storeDetails    <- map["store"]
        targetId        <- map["targetId"]
        cartItems       <- map["cartItems"]
    }
}

struct StoreDetailsDataSource : Mappable {
    
    var id          : String = ""
    var name        : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
    }
}

struct CartItemDataSource: Mappable {
    
    var id          : String = ""
    var product     : ProductDataSource? = nil
    var quantity    : Int = 0
    var isSelected  : Bool = false
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        product     <- map["product"]
        quantity    <- map["quantity"]
    }
}



import Foundation
import ObjectMapper

struct Cart : Codable {
    var cartDetail : [CartDetailForCheckout]?
    var couponIds : [String]?
    var recipient : Recipient?

}

struct CartDetailForCheckout : Codable {
    var selectedCartItems : [String]?
    var targetId : String?
    var carrierCode : String?

}

struct CartDetailReq : Codable {
    var cart : Cart?
    var includes : String?
    var paymentMethodCode : String?
    var paymentPlatform : String?

   
}

struct Recipient : Codable {
    var id : String?
    var createdAt : Int?
    var updatedAt : Int?
    var userId : String?
    var profileId : String?
    var firstName : String?
    var lastName : String?
    var email : String?
    var phone : String?
    var country : String?
    var region : String?
    var province : String?
    var district : String?
    var ward : String?
    var address : String?
    var postalCode : String?
    var latitude : Double?
    var longitude : Double?
    var isDefault : Bool?


}

