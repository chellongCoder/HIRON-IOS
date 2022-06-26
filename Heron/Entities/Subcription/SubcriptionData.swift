/* 

*/

import Foundation
import ObjectMapper

struct SubcriptionData : Mappable {
	var id : String?
	var subsItemId : String?
	var period : Int?
	var finalPrice : Int?
	var regularPrice : Int?
	var trialPrice : String?
	var status : String?
	var createdAt : Int?
	var updatedAt : Int?
	var subsItem : SubsItem?
	var gateways : [Gateways]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		subsItemId <- map["subsItemId"]
		period <- map["period"]
		finalPrice <- map["finalPrice"]
		regularPrice <- map["regularPrice"]
		trialPrice <- map["trialPrice"]
		status <- map["status"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
		subsItem <- map["subsItem"]
		gateways <- map["gateways"]
	}

}
