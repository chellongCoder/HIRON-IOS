/* 

*/

import Foundation
import ObjectMapper

enum OrderStatus: String {
    case PENDING    = "pending"
    case CONFIRMED  = "confirmed"
    case PROCESSING = "processing"
    case COMPLETED  = "completed"
    case CANCELED   = "canceled"
    case REJECTED   = "rejected"
    case EXPIRED    = "expired"
}

struct OrderDataSource : Mappable {
	var id              : String = ""
	var code            : String = ""
	var userId          : String?
	var targetId        : String?
	var orderPaymentId  : String?
	var featureType     : String?
    private var status  : OrderStatus = .PENDING
	var shipmentStatus  : String?
	var isPaid          : Bool?
	private var amount  : Int?
	var userData        : OrderUserMetadata?
	var createdAt       : Int?
	var updatedAt       : Int?
	var orderPayment    : OrderPayment?
	var items           : [OrderItems]?
	var orderReturns    : [String]?
	var coupons         : [String]?
	var paymentCoupons  : [String]?
	var attributeValues : [AttributeValues]?
    var store           : StoreDataSource?
    
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
		createdAt       <- map["createdAt"]
		updatedAt       <- map["updatedAt"]
		orderPayment    <- map["orderPayment"]
		items           <- map["items"]
		orderReturns    <- map["orderReturns"]
		coupons         <- map["coupons"]
		paymentCoupons  <- map["paymentCoupons"]
		attributeValues <- map["attributeValues"]
        store           <- map["store"]
        
        if let metaData = map.JSON["metadata"] as? [String: Any],
           let userData = metaData["user"] as? [String: Any] {
            self.userData = Mapper<OrderUserMetadata>().map(JSON: userData)
        }
        
        self.customAmount = Float(amount ?? 0)/100.0
	}

    func getOrderStatusValue() -> String {
        switch self.status {
        case .PENDING:
            return "Pending"
        case .CONFIRMED:
            return "Confirmed"
        case .PROCESSING:
            return "Processing"
        case .COMPLETED:
            return "Completed"
        case .CANCELED:
            return "Canceled"
        case .REJECTED:
            return "Rejected"
        case .EXPIRED:
            return "Expired"
        }
    }
}
