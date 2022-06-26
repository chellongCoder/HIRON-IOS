/* 

*/

import Foundation
import ObjectMapper

struct Subs : Mappable {
	var id : String?
	var name : String?
	var status : String?
	var createdAt : Int?
	var updatedAt : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		name <- map["name"]
		status <- map["status"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
	}

}
