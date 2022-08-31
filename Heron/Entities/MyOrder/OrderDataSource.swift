/* 

*/

import Foundation
import ObjectMapper

struct OrderDataSource : Mappable {
	var id              : String = ""
	var code            : String = ""
	var userId          : String?
	var targetId        : String?
	var orderPaymentId  : String?
	var featureType     : String?
	var status          : String?
	var shipmentStatus  : String?
	var isPaid          : Bool?
	private var amount  : Int?
	var metadata        : OrderUserMetadata?
	var createdAt       : Int?
	var updatedAt       : Int?
	var orderPayment    : OrderPayment?
	var items           : [OrderItems]?
	var orderReturns    : [String]?
	var coupons         : [String]?
	var paymentCoupons  : [String]?
	var attributeValues : [AttributeValues]?
    
    // custom
    var customAmount    : Float = 0.0

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id              <- map["id"]
		code            <- map["code"]
		userId          <- map["userId"]
		targetId        <- map["targetId"]
		orderPaymentId  <- map["orderPaymentId"]
		featureType     <- map["featureType"]
		status          <- map["status"]
		shipmentStatus  <- map["shipmentStatus"]
		isPaid          <- map["isPaid"]
		amount          <- map["amount"]
		metadata        <- map["metadata"]["user"]
		createdAt       <- map["createdAt"]
		updatedAt       <- map["updatedAt"]
		orderPayment    <- map["orderPayment"]
		items           <- map["items"]
		orderReturns    <- map["orderReturns"]
		coupons         <- map["coupons"]
		paymentCoupons  <- map["paymentCoupons"]
		attributeValues <- map["attributeValues"]
        
        self.customAmount = Float(amount ?? 0)/100.0
	}

}
