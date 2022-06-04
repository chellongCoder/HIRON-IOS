//
//  DeliveryServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

import ObjectMapper

class DeliveryServices {
    
    public static let sharedInstance = DeliveryServices()

    func getListUserAddress(completion:@escaping (String?, [ContactDataSource]?)-> Void) {
                
        let fullURLRequest = kGatewayDeliveryServicesURL+"/delivery-addresses/users/own"
        
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else {
                
                #warning("API_NEED_MAINTAIN")
                // API response array nhưng lại kẹp trong data.
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<ContactDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }

}
