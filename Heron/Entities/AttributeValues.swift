//
//  AttributedValues.swift
//  Heron
//
//  Created by Luu Luc on 09/08/2022.
//

import UIKit
import ObjectMapper

enum AttributeCode : String {
    case About          = "About"
    case WorkExperience = "WorkExperience"
    case Certificate    = "Certificate"
    case Dean           = "Dean"
    case Experience     = "Experience"
}

struct AttributeValues: Mappable {
    
    var id              : String = ""
    var attributeCode   : AttributeCode = .About
    var value           : String = ""
    var attribute       : Attribute?
    var entityId        : String?
    var createdAt       : Int?
    var updatedAt       : String?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id                  <- map["id"]
        value               <- map["value"]
        entityId            <- map["entityId"]
        attributeCode       <- map["attributeCode"]
        createdAt           <- map["createdAt"]
        updatedAt           <- map["updatedAt"]
        attribute           <- map["attribute"]
    }
}

struct Attribute : Mappable {
    
    var code            : AttributeCode = .About
    var label           : String = ""
    var type            : String?
    var status          : String?
    var sortOrder       : Int?
    var visibility      : Bool?
    var systemDefined   : Bool?
    var isRequired      : Bool?
    var editable        : Bool?
    var options         : String?
    var createdAt       : Int?
    var updatedAt       : String?
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        code            <- map["code"]
        label           <- map["label"]
        type            <- map["type"]
        status          <- map["status"]
        sortOrder       <- map["sortOrder"]
        visibility      <- map["visibility"]
        systemDefined   <- map["systemDefined"]
        isRequired      <- map["isRequired"]
        editable        <- map["editable"]
        options         <- map["options"]
        createdAt       <- map["createdAt"]
        updatedAt       <- map["updatedAt"]
    }
}
