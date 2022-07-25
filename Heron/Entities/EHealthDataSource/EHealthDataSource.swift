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
    var firstName   : String = ""
    var lastName    : String = ""
    var email       : String = ""
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
        email       <- map["email"]
    }
}
