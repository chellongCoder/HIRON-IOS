/* 

*/

import Foundation
import ObjectMapper

struct OrderItems : Mappable {
	var id              : String?
	var orderId         : String?
	var externalId      : String?
	var itemId          : String?
	var code            : String?
	var sku             : String?
	var name            : String?
	var shortDesc       : String?
	var regularPrice    : Int?
	var finalPrice      : Int?
	var currency        : String?
	var thumbnailUrl    : String?
	var quantity        : Int?
	var metadata        : ItemMetadata?
	var attributes      : [ItemAttributes]?
	var createdAt       : Int?
	var updatedAt       : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id              <- map["id"]
		orderId         <- map["orderId"]
		externalId      <- map["externalId"]
		itemId          <- map["itemId"]
		code            <- map["code"]
		sku             <- map["sku"]
		name            <- map["name"]
		shortDesc       <- map["shortDesc"]
		regularPrice    <- map["regularPrice"]
		finalPrice      <- map["finalPrice"]
		currency        <- map["currency"]
		thumbnailUrl    <- map["thumbnailUrl"]
		quantity        <- map["quantity"]
		metadata        <- map["metadata"]
		attributes      <- map["attributes"]
		createdAt       <- map["createdAt"]
		updatedAt       <- map["updatedAt"]
	}

}
