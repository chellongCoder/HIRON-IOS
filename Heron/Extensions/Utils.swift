//
//  Utils.swift
//  Heron
//
//  Created by Triet Nguyen on 19/05/2022.
//

import Foundation
class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}

class TimeConverter {
    func getDateFromInt(_ int: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(int/1000))
        
        return dateFormatter.string(from: date)
    }
}

func getMoneyFormat(_ value: Float?) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.numberStyle = .currencyAccounting
    return formatter.string(from: (value ?? 0.0) as NSNumber) ?? "$0.0"
}
