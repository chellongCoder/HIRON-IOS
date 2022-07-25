//
//  DoctorDataSource.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import ObjectMapper

class DoctorDataSource: Mappable {
    
    var id          : String = ""
    var userId      : String = ""
    var user        : DoctorUserDataSource?
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        userId      <- map["userId"]
        user        <- map["user"]
    }
}

struct DoctorUserDataSource : Mappable {
    
    var id          : String = ""
    var username    : String = ""
    var firstName   : String = ""
    var lastName    : String = ""
    var email       : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        username    <- map["username"]
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
        email       <- map["email"]
    }
}
