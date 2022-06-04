//
//  ContactDataSource.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import ObjectMapper

struct ContactDataSource: Mappable {
    
    var firstName       : String = ""
    var lastName        : String = ""
    var phone           : String = ""
    var email           : String = ""
    var address         : String = ""
    var country         : String = "Việt Nam"
    var province        : String = "HCM"
    var postalCode      : String = "70000"
    var isDefault       : Bool = false
    var latitude        : Double = 0.0
    var longitude       : Double = 0.0
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        firstName       <- map["firstName"]
        lastName        <- map["lastName"]
        phone           <- map["phone"]
        email           <- map["email"]
        address         <- map["address"]
        country         <- map["country"]
        province        <- map["province"]
        postalCode      <- map["postalCode"]
        isDefault       <- map["isDefault"]
        latitude        <- map["latitude"]
        longitude       <- map["longitude"]
    }
}
