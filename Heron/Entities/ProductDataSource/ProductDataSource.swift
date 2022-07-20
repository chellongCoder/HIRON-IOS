//
//  ProductDataSource.swift
//  Heron
//
//  Created by Luu Luc on 08/05/2022.
//

import UIKit
import ObjectMapper

enum ProductMediaType : String {
    case IMAGE      = "image"
    case VIDEO      = "video"
}

enum ProductType : String {
    case simple         = "simple"
    case configurable   = "configurable"
}

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
    
    // configurable product
    var type            : ProductType = .simple
    var configurableOptions : [ConfigurableOption] = []
    var children        : [ProductDataSource] = []
    var attributeValues : [ProductAttributeValue] = []
    
    // custome value
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
        
        type            <- map["type"]
        configurableOptions <- map["configurableOptions"]
        children        <- map["children"]
        attributeValues <- map["attributeValues"]
        
        self.discountPercent = Float(regularPrice - finalPrice)/Float(regularPrice) * 100
        self.customRegularPrice = Float(regularPrice)/100.0
        self.customFinalPrice = Float(finalPrice)/100.0
        
        if thumbnailUrl == nil {
            if let firstMedia = media.first(where: { productMedia in
                return (productMedia.type == "image") && (productMedia.value != nil)
            }) {
                thumbnailUrl = firstMedia.value
            }
        }
    }
    
    static func == (lhs: ProductDataSource, rhs: ProductDataSource) -> Bool {
        return lhs.id == rhs.id
    }
    
    func isMatchingWithVariants(_ variants: [SelectedVariant]) -> Bool {
        var isMatched = false
        for variant in variants {
            if self.attributeValues.contains(where: { productAttributeValue in
                return productAttributeValue.attributeCode == variant.attributeCode && productAttributeValue.value == variant.value
            }) {
                isMatched = true
            } else {
                return false
            }
        }
        
        return isMatched
    }
    
    func getMatchedChilProductWithVariants(_ variants: [SelectedVariant]) -> ProductDataSource? {
        
        for chilProduct in self.children {
            var isMatched = false
            for variant in variants {
                if self.attributeValues.contains(where: { productAttributeValue in
                    return productAttributeValue.attributeCode == variant.attributeCode && productAttributeValue.value == variant.value
                }) {
                    isMatched = true
                } else {
                    break
                }
            }
            
            if isMatched {
                // all variant matched
                return chilProduct
            }
        }
        
        return nil
    }
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

struct ConfigurableOption : Mappable {
    
    var code    : String = ""
    var label   : String = ""
    var values  : [String] = []
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        code    <- map["code"]
        label   <- map["label"]
        values  <- map["values"]
    }
}

struct ProductAttributeValue : Mappable {
    var id      : String = ""
    var value   : String = ""
    var attributeCode   : String = ""
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        value           <- map["value"]
        attributeCode   <- map["attributeCode"]
    }
}
