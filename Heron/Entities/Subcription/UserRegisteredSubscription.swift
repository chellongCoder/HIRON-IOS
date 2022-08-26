//
//  UserRegisteredSubscription.swift
//  Heron
//
//  Created by Luu Luc on 26/08/2022.
//

import ObjectMapper

class UserRegisteredSubscription: Mappable {
    
    var id              : String = ""
    private var price   : Int = 0
    var status          : SubscriptionStatus = .PENDING
    var subsPlan        : SubscriptionData?
    var subsPlanId      : String = ""
    var interval        : SubscriptionInterval?
    var interval_count  : Int = 1
    
    // custom
    var customPrice     : Float = 0.0
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        price       <- map["price"]
        status      <- map["status"]
        subsPlan    <- map["subsPlan"]
        subsPlanId  <- map["subsPlanId"]
        interval    <- map["interval"]
        interval_count  <- map["interval_count"]
        
        self.customPrice = Float(self.price)/1000.0
    }
}
