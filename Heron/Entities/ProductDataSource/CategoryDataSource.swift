//
//  CategoryDataSource.swift
//  Heron
//
//  Created by Luu Luc on 14/05/2022.
//

import UIKit
import ObjectMapper

class CategoryDataSource: Mappable {
    
    var name            : String = ""
    var id              : String = ""
    var code            : String = ""
    var thumbnailUrl    : String = ""
    var desc            : String = ""
    var visibility      : Bool = false
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        name            <- map["name"]
        id              <- map["id"]
        code            <- map["code"]
        thumbnailUrl    <- map["thumbnailUrl"]
        desc            <- map["desc"]
        visibility      <- map["visibility"]
    }
}
