/* 

*/

import Foundation
import ObjectMapper

struct OrderPayment : Mappable {
	var id : String?
	var paymentId : String?
	var methodCode : String?
	var type : String?
	var completedAt : Int?
	var metadata : PaymentMetadata?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		paymentId <- map["paymentId"]
		methodCode <- map["methodCode"]
		type <- map["type"]
		completedAt <- map["completedAt"]
		metadata <- map["metadata"]
	}

}
