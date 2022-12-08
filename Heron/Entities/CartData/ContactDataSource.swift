//
//  ContactDataSource.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import ObjectMapper

struct ContactDataSource: Mappable {
    
    var id              : String = ""
    var userId          : String = ""
    var firstName       : String = ""
    var lastName        : String = ""
    var phone           : String = ""
    var email           : String = ""
    var address         : String = ""
    var country         : String = ""
    var province        : String = ""
    var postalCode      : String = ""
    var isDefault       : Bool = false
    var latitude        : Double = 0.0
    var longitude       : Double = 0.0
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        userId          <- map["userId"]
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
    
    func isValidContact() -> Bool {
        return (firstName != "") && (lastName != "") && (phone != "") && (email != "") && (address != "") && (country != "") && (province != "") && (postalCode != "")
    }
}
