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
    var payment         : UserRegisteredSubPayment?
    var paymentId       : String = ""
    var enabledAt       : Int = 0
    var disabledAt      : Int = 0
    
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
        payment     <- map["payment"]
        paymentId   <- map["paymentId"]
        enabledAt   <- map["enabledAt"]
        disabledAt  <- map["disabledAt"]
        
        self.customPrice = Float(self.price)/1000.0
    }
    
    func isCurrentlyApplied() -> Bool {
        let currentMilisecond = Int(Date().timeIntervalSince1970)*1000
        if self.enabledAt <= currentMilisecond && self.disabledAt > currentMilisecond {
            return true
        }
        
        return false
    }
    
    func getStatusText() -> String {
        switch self.status {
        case .PENDING:
            return "Under Payment"
        case .ENABLED:
            return "Activated"
        case .CANCELLED:
            return "Cancelled"
        }
    }
}

struct UserRegisteredSubPayment: Mappable {
    
    var transaction     : UserRegisteredSubTransaction?
    var metadata        : UserRegisteredSubMetadata?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        transaction     <- map["transaction"]
        metadata        <- map["metadata"]
    }
}

struct UserRegisteredSubTransaction: Mappable {
    
    var id          : String = ""
    var status      : SubscriptionStatus = .PENDING
    var methodCode  : String = "subscription"
    var type        : String = "register_subscription"
    var source      : [String : Any] = [:]
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        status      <- map["status"]
        methodCode  <- map["methodCode"]
        type        <- map["type"]
        source      <- map["source"]
    }
}

struct UserRegisteredSubMetadata: Mappable {
    
    var clientSecret    : String = ""
    var customerId      : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        clientSecret        <- map["clientSecret"]
        customerId          <- map["customerId"]
    }
}
