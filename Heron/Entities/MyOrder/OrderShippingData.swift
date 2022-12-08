//
//  OrderShippingData.swift
//  Heron
//
//  Created by Luu Luc on 01/09/2022.
//

import UIKit
import ObjectMapper

class OrderShippingData: Mappable {
    
    var id              : String = ""
    var trackingNumber  : String = ""
    var recipient       : OrderShippingRecipient?
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        trackingNumber  <- map["trackingNumber"]
        recipient       <- map["recipient"]
    }
    
    struct OrderShippingRecipient: Mappable {
        var id          : String = ""
        var firstName   : String = ""
        var lastName    : String = ""
        var phone       : String = ""
        var address     : String = ""
        var ward        : String = ""
        var district    : String = ""
        var province    : String = ""
        var country     : String = ""
        
        init?(map: ObjectMapper.Map) {
            //
        }
        
        mutating func mapping(map: ObjectMapper.Map) {
            id          <- map["id"]
            firstName   <- map["firstName"]
            lastName    <- map["lastName"]
            phone       <- map["phone"]
            address     <- map["address"]
            ward        <- map["ward"]
            district    <- map["district"]
            province    <- map["province"]
            country     <- map["country"]
        }
        
        func getAddressString() -> String {
            var addressString = ""
            if !self.address.isEmpty {
                addressString += self.address + ", "
            }
            
            if !self.ward.isEmpty {
                addressString += self.ward + ", "
            }
            
            if !self.district.isEmpty {
                addressString += self.district + ", "
            }
            
            if !self.province.isEmpty {
                addressString += self.province + ", "
            }
            
            if !self.country.isEmpty {
                addressString += self.country + ", "
            }
            
            if (addressString.count >= 2) {
                addressString.removeLast(2)
            }
            return addressString
        }
    }
}
