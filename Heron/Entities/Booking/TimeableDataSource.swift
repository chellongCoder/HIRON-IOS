//
//  TimeableDataSource.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import ObjectMapper

class TimeableDataSource: Mappable, Equatable {
    
    var id          : String = ""
    var hostId      : String = ""
    var totalSlots  : Int = 0
    var totalUsage  : Int = 0
    var startTime   : Int = 0
    var endTime     : Int = 0
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        hostId      <- map["hostId"]
        totalSlots  <- map["totalSlots"]
        totalUsage  <- map["totalUsage"]
        startTime   <- map["startTime"]
        endTime     <- map["endTime"]
    }
    
    static func == (lhs: TimeableDataSource, rhs: TimeableDataSource) -> Bool {
        return lhs.id == rhs.id
    }
}
