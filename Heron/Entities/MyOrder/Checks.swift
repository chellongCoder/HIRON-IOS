/* 

*/

import Foundation
import ObjectMapper

struct Checks : Mappable {
	var address_line1_check : String?
	var address_postal_code_check : String?
	var cvc_check : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		address_line1_check <- map["address_line1_check"]
		address_postal_code_check <- map["address_postal_code_check"]
		cvc_check <- map["cvc_check"]
	}

}
