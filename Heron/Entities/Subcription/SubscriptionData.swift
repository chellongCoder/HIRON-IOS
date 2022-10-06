/* 

*/

import Foundation
import ObjectMapper

enum SubscriptionInterval : String {
    case day    = "day"
    case week   = "week"
    case month  = "month"
    case year   = "year"
}

enum SubscriptionStatus : String {
    case PENDING    = "pending"
    case ENABLED    = "enabled"
    case CANCELLED  = "cancelled"
    case DISABLE    = "disabled"
}

struct SubscriptionData : Mappable {
	var id              : String = ""
	var subsItemId      : String = ""
	private var finalPrice      : Int = 0
	private var regularPrice    : Int = 0
    var interval        : SubscriptionInterval = .day
    var interval_count  : Int = 1
	var status          : String?
	var createdAt       : Int?
	var updatedAt       : Int?
	var subsItem        : SubsItem?
	var gateways        : [SubscriptionGateways]?

    // custom
    var customFinalPrice    : Float = 0.0
    var customRegularPrice  : Float = 0.0
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id              <- map["id"]
        subsItemId      <- map["subsItemId"]
		finalPrice      <- map["finalPrice"]
		regularPrice    <- map["regularPrice"]
        interval        <- map["interval"]
        interval_count  <- map["interval_count"]
		status          <- map["status"]
		createdAt       <- map["createdAt"]
		updatedAt       <- map["updatedAt"]
		subsItem        <- map["subsItem"]
//		gateways        <- map["gateways"]
        
        self.customFinalPrice = Float(self.finalPrice)/100.0
        self.customRegularPrice = Float(self.regularPrice)/100.0
	}
}
