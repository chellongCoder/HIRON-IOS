//
//  VoucherDataSource.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import ObjectMapper

class VoucherDataSource: Mappable {
    
    var id      : String = ""
    var code    : String = ""
    var couponRule  : VoucherCouponRule? = nil
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        code    <- map["code"]
        couponRule  <- map["couponRule"]
    }
}

struct VoucherCouponRule: Mappable {
    
    var title   : String = ""
    var description : String = ""
    var discount    : Int = 0
    var isFixed     : Bool = false
    var startTime   : Int = 0
    var endTime     : Int = 0
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        title       <- map["title"]
        description <- map["description"]
        discount    <- map["discount"]
        isFixed     <- map["isFixed"]
        startTime   <- map["startTime"]
        endTime     <- map["endTime"]
    }
}
