/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

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