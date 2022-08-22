/* 

*/

import Foundation
import ObjectMapper

struct SubsItem : Mappable {
	var id          : String?
	var subsId      : String?
	var name        : String?
//	var status      : String?
//	var createdAt   : Int?
//	var updatedAt   : Int?
//	var subs        : Subs?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id          <- map["id"]
		subsId      <- map["subsId"]
		name        <- map["name"]
//		status      <- map["status"]
//		createdAt   <- map["createdAt"]
//		updatedAt   <- map["updatedAt"]
//		subs        <- map["subs"]
	}
}
