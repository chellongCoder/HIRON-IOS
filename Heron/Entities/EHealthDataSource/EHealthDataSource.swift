//
//  EHealthDataSource.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import ObjectMapper

class EHealthDataSource: Mappable {
    
    var id          : String = ""
    var userId      : String = ""
    var firstName   : String = ""
    var lastName    : String = ""
    var phone       : String = ""
    var email       : String = ""
    var avatar      : String = ""
    var gender      : UserGender = .male
    var dob         : Int = 0
    var identityNum : String = ""
    var profession  : String = ""
    var addressInfo : EHProfileAddress?
    
    var children    : [EHealthDataSource] = []
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        userId      <- map["userId"]
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
        phone       <- map["phone"]
        email       <- map["email"]
        avatar      <- map["avatar"]
        gender      <- map["gender"]
        dob         <- map["dob"]
        identityNum <- map["identityNum"]
        profession  <- map["profession"]
        addressInfo <- map["addressInfo"]
        
        children    <- map["children"]
    }
}

struct EHProfileAddress: Mappable {
    
    var country     : String = ""
    var region      : String = ""
    var province    : String = ""
    var district    : String = ""
    var ward        : String = ""
    var address     : String = ""
    var postalCode  : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        country     <- map["country"]
        region      <- map["region"]
        province    <- map["province"]
        district    <- map["district"]
        ward        <- map["ward"]
        address     <- map["address"]
        postalCode  <- map["postalCode"]
    }
}
