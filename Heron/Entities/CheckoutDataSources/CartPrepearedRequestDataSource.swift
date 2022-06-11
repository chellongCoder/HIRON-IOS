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
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        cartDetail  <- map["cartDetail"]
        couponIds   <- map["couponIds"]
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

// MARK: - CartPrepearedResponseDataSource
struct CartPrepearedResponseDataSource: Mappable {
    
    var checkoutPriceData : CartPrepearedResponseCheckoutPriceData?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        checkoutPriceData <- map["checkoutPriceData"]
    }
}

struct CartPrepearedResponseCheckoutPriceData: Mappable {
    
    var couponApplied : Int = 0
    var customTaxSubtotal : Int = 0
    private var merchandiseSubtotal : Int = 0
    var taxExemption : Int = 0
    var taxPayable : Int = 0
    private var totalPayable : Int = 0
    var vatSubtotal : Int = 0
    
    // Custom
    var customTotalPayable : Float = 0.0
    var customeMerchandiseSubtotal : Float = 0.0
    
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
        
        customTotalPayable = Float(totalPayable)/100.0
        customeMerchandiseSubtotal = Float(merchandiseSubtotal)/100.0
    }
}
