//
//  BookingAppointmentDataSource.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit
import ObjectMapper

enum BookingAppointmentStatus: String {
    case PENDING    = "pending"
    case CONFIRMED  = "confirmed"
    case PROCESSING = "processing"
    case COMPLETED  = "completed"
    case CANCELED   = "canceled"
    case REJECTED   = "rejected"
    case EXPIRED    = "expired"
}

class BookingAppointmentDataSource: Mappable {
    
    var id      : String = ""
    var code    : String = ""
    var status  : BookingAppointmentStatus = .PENDING
    var isPaid  : Bool = false
    private var amount  : Int = 0
    var startTime   : Int = 0
    var endTime     : Int = 0
    
    // custom
    var customAmount    : Float = 0.0
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        code        <- map["code"]
        status      <- map["status"]
        isPaid      <- map["isPaid"]
        amount      <- map["amount"]
        startTime   <- map["startTime"]
        endTime     <- map["endTime"]
        
        self.customAmount = Float(amount)/1000.0
    }
}
