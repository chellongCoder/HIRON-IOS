//
//  Organization.swift
//  Heron
//
//  Created by Luu Luc on 09/08/2022.
//

import UIKit
import ObjectMapper

class Organization: Mappable {
    
    var id              : String = ""
    var name            : String = ""
    var createdAt       : Int = 0
    var updatedAt       : Int = 0
    var attributeValues : [AttributeValues] = []
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        createdAt       <- map["createdAt"]
        updatedAt       <- map["updatedAt"]
        attributeValues <- map["attributeValues"]
    }
}
