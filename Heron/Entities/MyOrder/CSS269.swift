/* 

*/

import Foundation
import ObjectMapper

struct CSS269 : Mappable {
	var label : String?
	var sortOrder : Int?
	var value : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		label <- map["label"]
		sortOrder <- map["sortOrder"]
		value <- map["value"]
	}

}
