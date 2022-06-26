/* 

*/

import Foundation
import ObjectMapper

struct Card : Mappable {
	var brand : String?
	var checks : Checks?
	var country : String?
	var exp_month : Int?
	var exp_year : Int?
	var fingerprint : String?
	var funding : String?
	var installments : String?
	var last4 : String?
	var mandate : String?
	var network : String?
	var three_d_secure : String?
	var wallet : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		brand <- map["brand"]
		checks <- map["checks"]
		country <- map["country"]
		exp_month <- map["exp_month"]
		exp_year <- map["exp_year"]
		fingerprint <- map["fingerprint"]
		funding <- map["funding"]
		installments <- map["installments"]
		last4 <- map["last4"]
		mandate <- map["mandate"]
		network <- map["network"]
		three_d_secure <- map["three_d_secure"]
		wallet <- map["wallet"]
	}

}
