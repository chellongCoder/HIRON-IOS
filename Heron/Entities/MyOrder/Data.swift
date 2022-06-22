/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct OrderData : Mappable {
	var id : String?
	var code : String?
	var userId : String?
	var targetId : String?
	var orderPaymentId : String?
	var featureType : String?
	var status : String?
	var shipmentStatus : String?
	var isPaid : Bool?
	var amount : Int?
	var metadata : User?
	var createdAt : Int?
	var updatedAt : Int?
	var orderPayment : OrderPayment?
	var items : [Items]?
	var orderReturns : [String]?
	var coupons : [String]?
	var paymentCoupons : [String]?
	var attributeValues : [AttributeValues]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		code <- map["code"]
		userId <- map["userId"]
		targetId <- map["targetId"]
		orderPaymentId <- map["orderPaymentId"]
		featureType <- map["featureType"]
		status <- map["status"]
		shipmentStatus <- map["shipmentStatus"]
		isPaid <- map["isPaid"]
		amount <- map["amount"]
		metadata <- map["metadata"]["user"]
		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
		orderPayment <- map["orderPayment"]
		items <- map["items"]
		orderReturns <- map["orderReturns"]
		coupons <- map["coupons"]
		paymentCoupons <- map["paymentCoupons"]
		attributeValues <- map["attributeValues"]
	}

}
