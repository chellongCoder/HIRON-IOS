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
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<ProductDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func getListCategories(completion:@escaping (String?, [CategoryDataSource]?) -> Void) {
        
        let fullURLRequest = kGatwayInventoryURL + "/categories"
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage,
                               Mapper<CategoryDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func getProductDetails(productID: String, completion:@escaping (String?, ProductDataSource?)-> Void) {
        
        
        let fullURLRequest = kGatwayInventoryURL + "/products/" + productID
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                if let data = responseData.responseData?["data"] as? [String:Any] {
                    completion(responseData.responseMessage, Mapper<ProductDataSource>().map(JSON: data))
                    return
                }
            }
        }
    }
}
