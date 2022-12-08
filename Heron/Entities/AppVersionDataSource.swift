//
//  AppVersionDataSource.swift
//  Heron
//
//  Created by Triet Nguyen on 23/02/2021.
//  Copyright © 2021 Luu Lucas. All rights reserved.
//

import Foundation
import ObjectMapper

struct AppVersionDataSource: Mappable {
    var id: Int?
    var createdAt: Int?
    var updatedAt: Int?
    var platform: String?
    var minimumVersion: String?
    var currentVersion: String?
    var description: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id              <- map["id"]
        createdAt       <- map["createdAt"]
        updatedAt       <- map["updatedAt"]
        platform        <- map["platform"]
        minimumVersion  <- map["minimumVersion"]
        currentVersion  <- map["currentVersion"]
        description     <- map["description"]
    }

}
