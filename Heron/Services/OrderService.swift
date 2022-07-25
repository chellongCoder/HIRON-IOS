//
//  OrderService.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import ObjectMapper
import RxSwift
import RxRelay

class OrderService {
    
    public static let sharedInstance = OrderService()
    var orders            = BehaviorRelay<ProductDataSource?>(value: nil)
 
    private let disposeBag  = DisposeBag()
    
    func getMyOrders(param: [String:Any], completion:@escaping (String?, [OrderData]?) -> Void) {
        
        let fullURLRequest = kGatewayOrderURL + "/orders"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            } else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<OrderData>().mapArray(JSONArray: data))
                }
            }
        }
    }
}
