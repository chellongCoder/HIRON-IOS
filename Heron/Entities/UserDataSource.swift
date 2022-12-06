//
//  UserDataSource.swift
//  Heron
//
//  Created by Luu Lucas on 9/23/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import ObjectMapper

enum UserGender : String {
    case male   = "male"
    case female = "female"
}

class UserDataSource: Mappable {

    var userID :        String! = ""
    var userName :      String! = ""
    var password :      String  = ""
    var passwordConfirm :   String = ""
    var userFirstName : String  = ""
    var userLastName :  String  = ""
    var userPhoneNum :  String  = ""
    var userPhoneCode : String  = "+1"
    var userEmail :     String  = ""
    var userDOB :       Int  = 0
    var userGender :    UserGender = .male
    var identityNum :   String  = ""
    var userAvatarURL : String  = "https://sgp1.digitaloceanspaces.com/dev.storage/6bab1242-88c5-4705-81e9-3a9e13c47d41.png"

    required init?(map: Map) {
        //
    }

    func mapping(map: Map) {
        userID          <- map["id"]
        userName        <- map["username"]
        password        <- map["password"]
        passwordConfirm <- map["passwordConfirm"]
        userFirstName   <- map["firstName"]
        userLastName    <- map["lastName"]
        userPhoneNum    <- map["phoneNumber"]
        userPhoneCode   <- map["phoneCountryCode"]
        userEmail       <- map["email"]
        userDOB         <- map["dob"]
        userGender      <- map["gender"]
        identityNum     <- map["identityNum"]
        userAvatarURL   <- map["avatar"]
    }
}

struct LocationDataSource: Mappable {
    
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
