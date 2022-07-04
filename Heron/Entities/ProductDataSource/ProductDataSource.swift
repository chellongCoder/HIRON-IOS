//
//  ProductDataSource.swift
//  Heron
//
//  Created by Luu Luc on 08/05/2022.
//

import UIKit
import ObjectMapper

class ProductDataSource: Mappable, Equatable {
    
    var id              : String = ""
    var code            : String?
    var name            : String?
    var shortDesc       : String?
    var desc            : [ContentDescription] = []
    private var regularPrice    : Int = 0
    var finalPrice      : Int = 0
    var currency        : String?
    var thumbnailUrl    : String?
    var media           : [ProductMediaDataSource] = []
    var available       : Bool = false
    
    //custome value
    var discountPercent : Float = 0.0
    var quantity        : Int = 1
    var customRegularPrice  : Float = 0.0
    var customFinalPrice    : Float = 0.0
    
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
        self.customRegularPrice = Float(regularPrice)/100.0
        self.customFinalPrice = Float(finalPrice)/100.0
    }
    
    static func == (lhs: ProductDataSource, rhs: ProductDataSource) -> Bool {
        return lhs.id == rhs.id
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

struct ContentDescription : Mappable {
    
    var title       : String = ""
    var content     : String = ""
    var visibility  : Bool = true
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        title       <- map["title"]
        content     <- map["content"]
        visibility  <- map["visibility"]
    }
}
