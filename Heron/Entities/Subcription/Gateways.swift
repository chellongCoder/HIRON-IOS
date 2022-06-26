/* 

*/

import Foundation
import ObjectMapper

struct Gateways : Mappable {
	var id : String?
	var subsPlanId : String?
	var gateway : String?
	var gatewayPlanId : String?
	var status : String?
	var createdAt : Int?
	var updatedAt : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		subsPlanId <- map["subsPlanId"]
		gateway <- map["gateway"]
		gatewayPlanId <- map["gatewayPlanId"]
		status <- map["status"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
	}

}
