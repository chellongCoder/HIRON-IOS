//
//  SpecialtyDataSource.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import ObjectMapper

class DepartmentDataSource: Mappable {
    
    var id          : String = ""
    var name        : String = ""
    var code        : String = ""
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        code        <- map["code"]
    }
}


// https://ehp-api.cbidigital.com/organization-svc/api/departments?sort[createdAt]=desc&filter[type][eq]=specialty&filter[deletedAt][isNull]=true&limit=10&offset=0
