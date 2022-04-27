//
//  Date_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

extension Date {

    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    var startOfDay: Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }

//    func timeAgoDisplay() -> String {
//        let secondsAgo = Int(Date().timeIntervalSince(self))
//
//        let minute = 60
//        let hour = 60 * minute
//        let day = 24 * hour
//        let month = 30 * day
//
//        switch secondsAgo {
//        case let seconds where seconds < minute:
//            if secondsAgo == 0 {
//                return "Vừa xong"
//            }
//            return "\(secondsAgo) giây trước"
//        case let seconds where seconds < hour: return "\(secondsAgo / minute) phút trước"
//        case let seconds where seconds < day: return "\(secondsAgo / hour) giờ trước"
//        case let seconds where seconds < month: return "\(secondsAgo / day) ngày trước"
//        case let seconds where seconds >= month: return "\(secondsAgo / month) tháng trước"
//        default: return HMADateFormater().stringFromInt(fromInterval: Int(self.timeIntervalSince1970) * 1000)
//        }
//    }
}
