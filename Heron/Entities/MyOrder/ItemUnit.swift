/* 

*/

import Foundation
import ObjectMapper

struct ItemUnit : Mappable {
	var id : String?
	var name : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		name <- map["name"]
	}

}
