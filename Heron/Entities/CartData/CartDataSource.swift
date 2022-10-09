//
//  CartItemDataSource.swift
//  Heron
//
//  Created by Luu Luc on 19/05/2022.
//

import UIKit
import ObjectMapper
import RxSwift

struct CartDataSource : Mappable {
    
    private var subtotal    : Int = 0
    private var grandTotal  : Int = 0
    var totalSaved  : Int = 0
    var totalItemCount  : Int = 0
    var totalQuantity   : Int = 0
    var store           : [StoreDataSource] = []  // same as cartDetails - rename for clean flow
    
    // Custome
    var customSubTotal  : Float = 0.0
    var customGrandTotal : Float = 0.0
    
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
        
        customSubTotal = Float(subtotal)/100.0
        customGrandTotal = Float(grandTotal)/100.0
    }
    
    func hasItemSelected() -> Bool {
        for store in self.store {
            if store.isCheckoutSelected {
                return true
            }
            
            for item in store.cartItems {
                if item.isSelected {
                    return true
                }
            }
        }
        
        return false
    }
}

struct StoreDataSource : Mappable {
    
    var id              : String = ""
    var storeDetails    : StoreDetailsDataSource?
    var targetId        : String = ""
    var cartItems       : [CartItemDataSource] = []
    var shippingOrder   : CartShippingDataSource?
    
    private var orderTotal  : Int = 0
    
    // custom field
    var isCheckoutSelected  : Bool = false
    var customOrderTotal    : Float = 0.0
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        storeDetails    <- map["store"]
        targetId        <- map["targetId"]
        cartItems       <- map["cartItems"]
        shippingOrder   <- map["shippingOrder"]
        orderTotal      <- map["orderTotal"]
        
        customOrderTotal = Float(orderTotal)/100.0
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
    var product     : ProductDataSource?
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

struct CartShippingDataSource: Mappable {
    
    var carrier     : CartCarrierDataSource?
    var qoutes      : CartQoutesDataSource?
    
    // custom
    var amount      : Float = 0.0
    init?(map: Map) {
            
    }
    
    mutating func mapping(map: Map) {
        carrier <- map["carrier"]
        qoutes  <- map["quotes"]
        
        amount = Float(qoutes?.amount ?? 0) / 100.0
    }
}

struct CartCarrierDataSource: Mappable {
    
    var name                : String = ""
    private var updatedAt   : Int = 0
        
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        name        <- map["name"]
        updatedAt   <- map["updatedAt"]
    }
}

struct CartQoutesDataSource: Mappable {
    
    var estimatedTimeDropOff    : Int = 0
    var amount                  : Int = 0
    
    // custom
    var updatedAtStr        : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        estimatedTimeDropOff    <- map["estimatedTimeDropOff"]
        amount                  <- map["amount"]
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(estimatedTimeDropOff/1000))
        self.updatedAtStr = date.toString(dateFormat: "MMM dd, yyyy")
    }
}
