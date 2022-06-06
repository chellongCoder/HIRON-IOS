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
    
    func getListVouchers(completion:@escaping (String?, [VoucherDataSource]?)-> Void) {
        #warning("HARD_CODE")
        let fullURLRequest = kGatwayPromotionURL + "/coupons?limit=100&offset=0"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<VoucherDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
}
