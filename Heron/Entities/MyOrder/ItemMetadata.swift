/* 

*/

import Foundation
import ObjectMapper

struct ItemMetadata : Mappable {
	var code        : String?
	var name        : String?
	var shortDesc   : String?
	var slug        : String?
	var type        : String?
	var featureType : String?
	var category    : ItemCategory?
	var unit        : ItemUnit?
	var brand       : ItemBrand?
	var parent      : String?
	var attributes  : ItemAttributes?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		code        <- map["code"]
		name        <- map["name"]
		shortDesc   <- map["shortDesc"]
		slug        <- map["slug"]
		type        <- map["type"]
		featureType <- map["featureType"]
		category    <- map["category"]
		unit        <- map["unit"]
		brand       <- map["brand"]
		parent      <- map["parent"]
		attributes  <- map["attributes"]
	}

}
