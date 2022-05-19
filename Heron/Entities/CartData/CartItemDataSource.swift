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
    var store           : [StoreDataSource] = []
    
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
    }
}

struct StoreDataSource : Mappable {
    
    var id              : String = ""
    var storeDetails    : StoreDetailsDataSource? = nil
    var cartItems       : [CartItemDataSource] = []
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        storeDetails    <- map["store"]
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
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        product     <- map["product"]
        quantity    <- map["quantity"]
    }
}
