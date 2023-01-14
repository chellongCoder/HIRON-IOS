//
//  CheckoutDataSources.swift
//  Heron
//
//  Created by Luu Luc on 09/06/2022.
//

import UIKit
import ObjectMapper

// MARK: - CartPrepearedRequestDataSource
struct CartPrepearedRequestDataSource : Mappable {
    
    var cartDetail  : [CartPrepearedRequestCartDetail] = []
    var couponIds   : [String] = []
    var recipient   : CartPrepearedRequestReceipt?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        cartDetail  <- map["cartDetail"]
        couponIds   <- map["couponIds"]
        recipient   <- map["recipient"]
    }
}

struct CartPrepearedRequestCartDetail : Mappable {
    
    var selectedCartItems: [String] = []
    var targetId: String?
    var carrierCode: String = "grab"
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        selectedCartItems   <- map["selectedCartItems"]
        targetId            <- map["targetId"]
        carrierCode         <- map["carrierCode"]
    }
}

struct CartPrepearedRequestReceipt: Mappable {
    
    var firstName   : String = ""
    var lastName    : String = ""
    var phone       : String = ""
    var email       : String = ""
    var address     : String = ""
    var country     : String = ""
    var province    : String = ""
    var postalCode  : String = ""
    var isDefault   : Bool = false
    var latitude    : Double = 0.0
    var longitude   : Double = 0.0
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
        phone       <- map["phone"]
        email       <- map["email"]
        address     <- map["address"]
        country     <- map["country"]
        province    <- map["province"]
        postalCode  <- map["postalCode"]
        isDefault   <- map["isDefault"]
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
    }
}

// MARK: - CartPrepearedResponseDataSource
struct CartPrepearedResponseDataSource: Mappable {
    
    var checkoutPriceData : CartPrepearedResponseCheckoutPriceData?
    var cartDetail        : [StoreDataSource] = []
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        checkoutPriceData   <- map["checkoutPriceData"]
        cartDetail          <- map["cartDetail"]
    }
    
    func countProductSelected() -> Int {
        var returnValue = 0
        for store in cartDetail {
            returnValue += store.cartItems.count
        }
        
        return returnValue
    }
}

struct CartPrepearedResponseCheckoutPriceData: Mappable {
    
    private var couponApplied : Int = 0
    var customTaxSubtotal : Int = 0
    private var merchandiseSubtotal : Int = 0
    var taxExemption : Int = 0
    private var totalPayable : Int = 0
    private var shippingSubtotal : Int = 0
    private var taxPayable : Int = 0
    var vatSubtotal : Int = 0
    
    // Custom
    var customTotalPayable : Float = 0.0
    var customMerchandiseSubtotal : Float = 0.0
    var customShippingSubtotal : Float = 0.0
    var customTaxPayable : Float = 0.0
    var customCouponApplied : Float = 0.0
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        couponApplied       <- map["couponApplied"]
        customTaxSubtotal   <- map["customTaxSubtotal"]
        merchandiseSubtotal <- map["merchandiseSubtotal"]
        taxExemption        <- map["taxExemption"]
        taxPayable          <- map["taxPayable"]
        totalPayable        <- map["totalPayable"]
        vatSubtotal         <- map["vatSubtotal"]
        shippingSubtotal    <- map["shippingSubtotal"]
        
        customTotalPayable = Float(totalPayable)/100.0
        customMerchandiseSubtotal = Float(merchandiseSubtotal)/100.0
        customShippingSubtotal = Float(shippingSubtotal)/100.0
        customTaxPayable = Float(taxPayable)/100.0
        customCouponApplied = Float(couponApplied)/100.0
    }
}
