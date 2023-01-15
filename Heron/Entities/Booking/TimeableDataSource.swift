//
//  TimeableDataSource.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import ObjectMapper

enum TimeableBlockType {
    case morning
    case afternoon
    case evening
}

class TimeableDataSource: Mappable, Equatable {
    
    var id          : String = ""
    var hostId      : String = ""
    var totalSlots  : Int = 0
    var totalUsage  : Int = 0
    var startTime   : Int = 0
    var endTime     : Int = 0
    var blockType   : TimeableBlockType = .morning
    
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
        
        self.convertType()
    }
    
    static func == (lhs: TimeableDataSource, rhs: TimeableDataSource) -> Bool {
        return lhs.id == rhs.id
    }
    
    func convertType() {
        let date = Date.init(timeIntervalSince1970: TimeInterval(self.startTime / 1000))
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 0..<12 :
            self.blockType = .morning
        case 12..<18 :
            self.blockType = .afternoon
        case 17..<24 :
            self.blockType = .evening
        default:
            self.blockType = .morning
        }
    }
}
