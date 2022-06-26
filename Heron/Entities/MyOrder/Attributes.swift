/* 

*/

import Foundation
import ObjectMapper

struct Attributes : Mappable {
	var id : String?
	var orderItemId : String?
	var key : String?
	var value : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		orderItemId <- map["orderItemId"]
		key <- map["key"]
		value <- map["value"]
	}

}
