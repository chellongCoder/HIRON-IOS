//
//  ReviewDataSource.swift
//  Heron
//
//  Created by Lucas on 1/5/23.
//

import ObjectMapper

struct ReviewDataSource: Mappable {
    
    var userName        : String = "Michelle Stewart"
    var rate            : Int = 5
    var date            : Date = Date()
    var reviewContent   : String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
    var likeCount       : Int = 99
    
    init?(map: Map) {
        //
    }
    
    mutating func mapping(map: Map) {
        userName        <- map["userName"]
        rate            <- map["rate"]
        date            <- map["date"]
        reviewContent   <- map["reviewContent"]
        likeCount       <- map["likeCount"]
    }
}
