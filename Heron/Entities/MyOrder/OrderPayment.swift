/* 

*/

import Foundation
import ObjectMapper

struct OrderPayment : Mappable {
	var id          : String?
	var paymentId   : String?
	var methodCode  : String?
	var type        : String?
	var completedAt : Int = 0
	var metadata    : PaymentMetadata?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id          <- map["id"]
		paymentId   <- map["paymentId"]
		methodCode  <- map["methodCode"]
		type        <- map["type"]
        completedAt <- map["completedAt"]
		metadata    <- map["metadata"]
	}

}
struct PaymentMetadata : Mappable {
    var checkoutPriceData   : CheckoutPriceData?
    var priceDiscount       : Int?
    var card                : OrderCard?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        checkoutPriceData   <- map["checkoutPriceData"]
        priceDiscount       <- map["priceDiscount"]
        card                <- map["card"]
    }

}
