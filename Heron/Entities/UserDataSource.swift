//
//  UserDataSource.swift
//  Heron
//
//  Created by Luu Lucas on 9/23/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import ObjectMapper

class UserDataSource: Mappable {

    var userID: String! = ""
    var userName: String! = ""
    var userFullName: String  = ""
    var userPhoneNum: String  = ""
    var userEmail: String  = ""
    var userDOB: Int  = 0
    var userGender: String  = "male"
    var userAvatarURL: String  = ""

    required init?(map: Map) {
        //
    }

    func mapping(map: Map) {
        userID          <- map["id"]
        userName        <- map["username"]
        userFullName    <- map["fullname"]
        userPhoneNum    <- map["phone"]
        userEmail       <- map["email"]
        userDOB         <- map["dob"]
        userGender      <- map["gender"]
        userAvatarURL   <- map["avatar"]
    }
}

struct locationDataSource: Mappable {
    
    var id: Int          = 0
    var location: String = ""
    var isDefault: Bool  = false
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id          <- map["id"]
        location    <- map["location"]
        isDefault   <- map["isDefault"]
    }
}
