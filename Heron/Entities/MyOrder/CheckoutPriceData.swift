/* 

*/

import Foundation
import ObjectMapper

struct CheckoutPriceData : Mappable {
	var insuranceDiscountSubtotal   : Int?
	var couponApplied               : Int?
	var customTaxSubtotal           : Int?
	var insuranceBeforeDiscountSubtotal : Int?
	var insuranceSubtotal           : Int?
	var merchandiseSubtotal         : Int?
	var shippingDiscountSubtotal    : Int?
	var shippingSubtotal            : Int?
	var shippingSubtotalBeforeDiscount : Int?
	var taxExemption                : Int?
	var taxPayable                  : Int?
	private var totalPayable        : Int = 0
	var vatSubtotal                 : Int?
    
    // Custom
    var customTotalPayable          : Float = 0.0

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
		insuranceDiscountSubtotal   <- map["insuranceDiscountSubtotal"]
		couponApplied               <- map["couponApplied"]
		customTaxSubtotal           <- map["customTaxSubtotal"]
		insuranceBeforeDiscountSubtotal <- map["insuranceBeforeDiscountSubtotal"]
		insuranceSubtotal           <- map["insuranceSubtotal"]
		merchandiseSubtotal         <- map["merchandiseSubtotal"]
		shippingDiscountSubtotal    <- map["shippingDiscountSubtotal"]
		shippingSubtotal            <- map["shippingSubtotal"]
		shippingSubtotalBeforeDiscount <- map["shippingSubtotalBeforeDiscount"]
		taxExemption                <- map["taxExemption"]
		taxPayable                  <- map["taxPayable"]
		totalPayable                <- map["totalPayable"]
		vatSubtotal                 <- map["vatSubtotal"]
        
        customTotalPayable = Float(self.totalPayable)/1000.0
	}
}
