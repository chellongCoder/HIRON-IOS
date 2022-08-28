//
//  SubcriptionServives.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit
import ObjectMapper

class SubscriptionService: NSObject {
    public static let sharedInstance =  SubscriptionService()
    
    func getUserRegisteredSubscriptionPlan(completion:@escaping (String?, [UserRegisteredSubscription]?)-> Void) {
        let fullURLRequest = kGatewayPaymentURL + "/user-subs"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<UserRegisteredSubscription>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func getListSubscription(completion:@escaping (String?, [SubscriptionData]?)-> Void) {
        let fullURLRequest = kGatewayPaymentURL + "/subs-plans?filter[trialPrice][eq]=null"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<SubscriptionData>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func registerSubscriptionPlan(_ subscriptionData: SubscriptionData,
                                  completion:@escaping (String?, UserRegisteredSubscription?) -> Void) {
        let param : [String: Any] = ["subsPlanId" : subscriptionData.id,
                                     "gateway":subscriptionData.gateways?.first?.gateway ?? "stripe",
                                     "paymentMethodCode": "subscription",
                                     "paymentPlatform": "web_browser"]
        let fullURLRequest = kGatewayPaymentURL + "/user-subs"
        _ = _AppDataHandler.post(parameters: param, fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [String:Any] {
                    completion(responseData.responseMessage, Mapper<UserRegisteredSubscription>().map(JSON: data))
                }
            }
        }
    }
    
    func cancelImmediatelySubscription(_ subscriptionData: UserRegisteredSubscription, completion:@escaping (String?, String?) -> Void) {
        let param : [String: Any] = ["subsPlanId" : subscriptionData.subsPlanId,
                                     "gateway": "stripe",
                                     "paymentMethodCode": "subscription",
                                     "paymentPlatform": "web_browser",
                                     "immediately": true]
        let fullURLRequest = String(format: "%@%@%@", kGatewayPaymentURL, "/user-subs/cancel/", subscriptionData.id)
        _ = _AppDataHandler.post(parameters: param, fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {
                completion(nil, responseData.responseMessage)
            }
        }
    }
}
