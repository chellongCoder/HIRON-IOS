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
    var dob         : String = ""
    var identityNum : String = ""
    var profession  : String = ""
    var addressInfo : ContactDataSource?
    
    var children    : [EHealthDataSource] = []
    var parentId    : String = ""
    
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
        parentId    <- map["parentId"]
    }
}
