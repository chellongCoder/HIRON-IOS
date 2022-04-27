//
//  ResponseDataSource.swift
//  Heron
//
//  Created by Luu Lucas on 26/11/2020.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import ObjectMapper

struct ResponseDataSource: Mappable {

    var successMessage: String?
    var errorMessage: String?
    var objectData: [String: Any]?
    var objectList: [[String: Any]] = []
    var objectPaging: PagingDataSource?

    // Mappable
    init?(map: Map) {
        //
    }

    mutating func mapping(map: Map) {
        successMessage  <- map["message"]
        errorMessage     <- map["error"]
        objectData      <- map["data"]
        objectList      <- map["data"]
        objectPaging    <- map["pagination"]
    }
}


class PagingDataSource: Mappable {

    var skip: Int = 0
    var total: Int = 0
    var limit: Int = 0
    var totalPage: Int = 0
    required init?(map: Map) {
        //
    }

    func mapping(map: Map) {
        skip           <- map["skip"]
        total          <- map["total"]
        limit          <- map["limit"]
        totalPage      <- map["totalPage"]
    }
}
