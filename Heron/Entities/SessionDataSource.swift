//
//  SessionDataSource.swift
//  Heron
//
//  Created by Luu Lucas on 9/23/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import ObjectMapper

class SessionDataSource: Mappable {

    var accessToken: String! = ""
    var refreshToken: String! = ""

    required init?(map: Map) {
        //
    }

    func mapping(map: Map) {
        accessToken     <- map["accessToken"]
        refreshToken    <- map["refreshToken"]
    }
}
