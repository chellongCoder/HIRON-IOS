/* 

*/

import Foundation
import ObjectMapper

struct OrderUserMetadata : Mappable {
	var username        : String?
	var firstName       : String?
	var lastName        : String?
	var identityNum     : String?
	var email           : String?
	var phone           : String?
	var dob             : Int?
	var gender          : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		username        <- map["username"]
		firstName       <- map["firstName"]
		lastName        <- map["lastName"]
		identityNum     <- map["identityNum"]
		email           <- map["email"]
		phone           <- map["phone"]
		dob             <- map["dob"]
		gender          <- map["gender"]
	}

}
