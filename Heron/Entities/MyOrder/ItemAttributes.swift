/* 

*/

import Foundation
import ObjectMapper

struct ItemAttributes : Mappable {
	var id          : String?
	var orderItemId : String?
	var key         : String?
    var label       : String?
	var value       : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id          <- map["id"]
		orderItemId <- map["orderItemId"]
		key         <- map["key"]
        label       <- map["label"]
		value       <- map["value"]
	}

}
