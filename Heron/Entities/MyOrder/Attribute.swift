/* 

*/

import Foundation
import ObjectMapper

struct Attribute : Mappable {
	var code : String?
	var label : String?
	var type : String?
	var status : String?
	var sortOrder : Int?
	var visibility : Bool?
	var systemDefined : Bool?
	var isRequired : Bool?
	var editable : Bool?
	var options : String?
	var createdAt : Int?
	var updatedAt : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		code <- map["code"]
		label <- map["label"]
		type <- map["type"]
		status <- map["status"]
		sortOrder <- map["sortOrder"]
		visibility <- map["visibility"]
		systemDefined <- map["systemDefined"]
		isRequired <- map["isRequired"]
		editable <- map["editable"]
		options <- map["options"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
	}

}
