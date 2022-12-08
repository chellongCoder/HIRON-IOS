/* 

*/

import Foundation
import ObjectMapper

struct ItemBrand : Mappable {
	var id              : String?
	var code            : String?
	var name            : String?
	var thumbnailUrl    : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id              <- map["id"]
		code            <- map["code"]
		name            <- map["name"]
		thumbnailUrl    <- map["thumbnailUrl"]
	}

}
