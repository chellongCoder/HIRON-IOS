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
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<ContactDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func createNewUserAddress(newContact: ContactDataSource, completion:@escaping (String?, Bool)-> Void) {
        
        let fullURLRequest = kGatewayDeliveryServicesURL+"/delivery-addresses"
        
        _ = _AppDataHandler.post(parameters: newContact.toJSON(), fullURLRequest: fullURLRequest) { responseData in
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, false)
                return
            }
            else if responseData.responseCode >= 500 {
                return
            } else if responseData.responseCode == 201 {
                // created
                completion(nil, true)
            } else {
                completion(responseData.responseMessage, false)
            }
        }
    }

}
