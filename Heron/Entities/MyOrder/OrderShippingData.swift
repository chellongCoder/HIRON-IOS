//
//  OrderShippingData.swift
//  Heron
//
//  Created by Luu Luc on 01/09/2022.
//

import UIKit
import ObjectMapper

class OrderShippingData: Mappable {
    
    var id              : String = ""
    var trackingNumber  : String = "Unknow"
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        trackingNumber  <- map["trackingNumber"]
    }
}
