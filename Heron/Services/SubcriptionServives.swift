//
//  SubcriptionServives.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit
import ObjectMapper

class SubcriptionServices: NSObject {
    public static let sharedInstance =  SubcriptionServices()
    
    func getListSubscription(completion:@escaping (String?, [SubcriptionData]?)-> Void) {
        #warning("HARD_CODE")
        let fullURLRequest = kGatewayPaymentURL + "/subs-plans"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<SubcriptionData>().mapArray(JSONArray: data))
                }
            }
        }
    }
}
