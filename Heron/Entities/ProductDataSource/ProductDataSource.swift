//
//  ProductDataSource.swift
//  Heron
//
//  Created by Luu Luc on 08/05/2022.
//

import UIKit
import ObjectMapper

class ProductDataSource: Mappable {
    
    var id              : String = ""
    var code            : String?
    var name            : String?
    var shortDesc       : String?
    var desc            : [String] = []
    var regularPrice    : Int = 0
    var finalPrice      : Int = 0
    var currency        : String?
    var thumbnailUrl    : String?
    var media           : [ProductMediaDataSource] = []
    var available       : Bool = false
    
    //custome value
    var discountPercent : Float = 0.0
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        code        <- map["code"]
        name        <- map["name"]
        shortDesc   <- map["shortDesc"]
        desc        <- map["desc"]
        regularPrice    <- map["regularPrice"]
        finalPrice      <- map["finalPrice"]
        currency        <- map["currency"]
        thumbnailUrl    <- map["thumbnailUrl"]
        media           <- map["media"]
        available       <- map["available"]
        
        self.discountPercent = Float(regularPrice - finalPrice)/Float(regularPrice) * 100
    }
}

enum ProductMediaType : String {
    case IMAGE      = "image"
    case VIDEO      = "video"
}

class ProductMediaDataSource : Mappable {
    
    var type            : String?
    var value           : String?
    var sortOrder       : Int = 0
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        type        <- map["type"]
        value       <- map["value"]
        sortOrder   <- map["sortOrder"]
    }
}
