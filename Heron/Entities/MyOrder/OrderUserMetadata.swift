/* 

*/

import Foundation
import ObjectMapper

struct OrderUserMetadata : Mappable {
	var username            : String?
	var firstName           : String?
	var lastName            : String?
	var identityNum         : String?
	var email               : String?
	var phoneNumber         : String?
    var phoneCountryCode    : String = "+84"
	var dob                 : Int?
	var gender              : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
		username            <- map["username"]
		firstName           <- map["firstName"]
		lastName            <- map["lastName"]
		identityNum         <- map["identityNum"]
		email               <- map["email"]
        phoneNumber         <- map["phoneNumber"]
        phoneCountryCode    <- map["phoneCountryCode"]
		dob                 <- map["dob"]
		gender              <- map["gender"]
	}

}
