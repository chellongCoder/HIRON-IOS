//
//  SpecialtyDataSource.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import ObjectMapper

class TeamDataSource: Mappable {
    
    var id              : String = ""
    var departmentID    : String = ""
    var department      : DepartmentDataSource?
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        department      <- map["department"]
        departmentID    <- map["departmentId"]
    }
}

struct DepartmentDataSource : Mappable {
    
    var id              : String = ""
    var name            : String = ""
    var code            : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        code            <- map["code"]
    }
}
