//
//  DoctorDataSource.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import ObjectMapper

class DoctorDataSource: Mappable {
    
    var id              : String = ""
    var userId          : String = ""
    var attributeValues : [DoctorAttributeValues] = []
    var user            : DoctorUser?
    var teamMemberPosition  : [DoctorTeamMemberPosition] = []
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        userId          <- map["userId"]
        attributeValues <- map["attributeValues"]
        user            <- map["user"]
        teamMemberPosition  <- map["teamMemberPosition"]
    }
}

struct DoctorUser : Mappable {
    
    var id          : String = ""
    var username    : String = ""
    var firstName   : String = ""
    var lastName    : String = ""
    var email       : String = ""
    var avatar      : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        username    <- map["username"]
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
        email       <- map["email"]
        avatar      <- map["avatar"]
    }
}

enum DoctorAttributeCode : String {
    case About          = "About"
    case WorkExperience = "WorkExperience"
    case Certificate    = "Certificate"
    case Dean           = "Dean"
    case Experience     = "Experience"
}

struct DoctorAttributeValues : Mappable {
    
    var id              : String = ""
    var attributeCode   : DoctorAttributeCode = .About
    var value           : String = ""
    var attribute       : DoctorAttribute?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        attributeCode   <- map["attributeCode"]
        value           <- map["value"]
        attribute       <- map["attribute"]
    }
}

struct DoctorAttribute : Mappable {
    
    var code        : DoctorAttributeCode = .About
    var label       : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        code        <- map["code"]
        label       <- map["label"]
    }
}

struct DoctorTeamMemberPosition : Mappable {
    
    var teamId          : String = ""
    var memberId        : String = ""
    var team            : DoctorTeamMemberPositionTeam?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        teamId      <- map["teamId"]
        memberId    <- map["memberId"]
        team        <- map["team"]
    }
}

struct DoctorTeamMemberPositionTeam : Mappable {
    
    var id              : String = ""
    var departmentId    : String = ""
    var name            : String = ""
    var department      : DepartmentDataSource?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        departmentId    <- map["departmentId"]
        name            <- map["name"]
        department      <- map["department"]
    }
}
