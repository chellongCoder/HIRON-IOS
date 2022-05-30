//
//  ProductionServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

import ObjectMapper

class InventoryServices {
    
    public static let sharedInstance = InventoryServices()
    
    func getListProducts(param: [String:Any], completion:@escaping (String?, [ProductDataSource]?)-> Void) {
        
        let fullURLRequest = kGatwayInventoryURL + "/products"
        _ = _AppDataHandler.get(parameters: param, fullURLRequest: fullURLRequest) { responseData in
                        
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
                    completion(responseData.responseMessage, Mapper<ProductDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func getListCategories(completion:@escaping (String?, [CategoryDataSource]?)-> Void) {
        
        let fullURLRequest = kGatwayInventoryURL + "/categories"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
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
                    completion(responseData.responseMessage,
                               Mapper<CategoryDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
}
