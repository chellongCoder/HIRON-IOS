/* 

*/

import Foundation
import ObjectMapper

struct SubcriptionData : Mappable {
	var id              : String?
	var subsItemId      : String?
	var period          : Int?
	private var finalPrice      : Int = 0
//	var regularPrice    : Int?
	var trialPrice      : String?
	var status          : String?
	var createdAt       : Int?
	var updatedAt       : Int?
	var subsItem        : SubsItem?
//	var gateways        : [Gateways]?

    // custom
    var customFinalPrice    : Float = 0.0
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id              <- map["id"]
		subsItemId      <- map["subsItemId"]
		period          <- map["period"]
		finalPrice      <- map["finalPrice"]
//		regularPrice    <- map["regularPrice"]
		trialPrice      <- map["trialPrice"]
		status          <- map["status"]
		createdAt       <- map["createdAt"]
		updatedAt       <- map["updatedAt"]
		subsItem        <- map["subsItem"]
//		gateways        <- map["gateways"]
        
        self.customFinalPrice = Float(self.finalPrice)/1000.0
	}

}
