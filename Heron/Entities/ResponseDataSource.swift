//
//  ResponseDataSource.swift
//  Heron
//
//  Created by Luu Lucas on 26/11/2020.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import ObjectMapper

struct ResponseDataSource {
    
    var responseCode        : Int = 0
    var responseMessage     : String?
    var responseData        : [String:Any]?
    var responseList        : [[String:Any]] = []
}
