/* 

*/

import Foundation
import ObjectMapper

struct AttributeValues : Mappable {
	var id : String?
	var value : String?
	var entityId : String?
	var attributeCode : String?
	var createdAt : Int?
	var updatedAt : String?
	var attribute : Attribute?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		value <- map["value"]
		entityId <- map["entityId"]
		attributeCode <- map["attributeCode"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
		attribute <- map["attribute"]
	}

}
