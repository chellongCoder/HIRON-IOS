//
//  PromotionServices.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import ObjectMapper

class PromotionServices: NSObject {
    public static let sharedInstance = PromotionServices()
    
    func getListVouchers(completion:@escaping (String?, [VoucherDataSource]?) -> Void) {
        let fullURLRequest = kGatwayPromotionURL + "/coupons?limit=100&offset=0"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<VoucherDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
}
