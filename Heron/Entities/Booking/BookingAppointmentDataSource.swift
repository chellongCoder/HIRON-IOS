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
    var hostId  : String = ""
    var code    : String = ""
    var status  : BookingAppointmentStatus = .PENDING
    var isPaid  : Bool = false
    private var amount  : Int = 0
    var startTime   : Int = 0
    var endTime     : Int = 0
    var createdAt    : Int = 0
    var profile     : EHealthDataSource?
    var store       : StoreDataSource?
    var departmentID: String?
    
    // custom
    var customAmount    : Float = 0.0
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        hostId      <- map["hostId"]
        code        <- map["code"]
        status      <- map["status"]
        isPaid      <- map["isPaid"]
        amount      <- map["amount"]
        startTime   <- map["startTime"]
        endTime     <- map["endTime"]
        createdAt   <- map["createdAt"]
        profile     <- map["profile"]
        store       <- map["store"]
        
        self.customAmount = Float(amount)/100.0
        if let item = map.JSON["item"] as? [String: Any],
           let metadata = item["metadata"] as? [String: Any],
           let systemAttributes = metadata["systemAttributes"]  as? [String: Any],
           let department_id = systemAttributes["department_id"] as? [String: Any] {
            self.departmentID = department_id["value"] as? String
        }
        
    }
    
    func getStatusLabel() -> String {
        switch self.status {
        case .PENDING:
            return "PENDING"
        case .CONFIRMED:
            return "CONFIRMED"
        case .PROCESSING:
            return "PROCESSING"
        case .COMPLETED:
            return "COMPLETED"
        case .CANCELED:
            return "CANCELED"
        case .REJECTED:
            return "REJECTED"
        case .EXPIRED:
            return "EXPIRED"
        }
    }
}
