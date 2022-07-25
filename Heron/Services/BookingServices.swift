//
//  BookingServices.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper

class BookingServices {
    public static let sharedInstance    = BookingServices()
    
    var selectedProfile                 = BehaviorRelay<EHealthDataSource?>(value: nil)
    var selectedDepartment              = BehaviorRelay<DepartmentDataSource?>(value: nil)
    var selectedDoctor                  = BehaviorRelay<DoctorDataSource?>(value: nil)
    private let disposeBag              = DisposeBag()
    
    #warning("HARD_CODE")
    func getListEHProfile(completion:@escaping (String?, [EHealthDataSource]?) -> Void) {
        
        let fullURLRequest = kGatewayEHealthProfileURL + "/profiles/users/own"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            } else if responseData.responseCode >= 500 {
                return
            } else {
                
                #warning("API_NEED_MAINTAIN")
                // API response array nhưng lại kẹp trong data.
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<EHealthDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func getListDoctors(completion:@escaping (String?, [DoctorDataSource]?) -> Void) {
        
        let fullURLRequest = kGatewayOganizationURL + "/members?page=1&offset=0&limit=10&sort[createdAt]=desc&filter[type][eq]=doctor&filter[deletedAt][eq]=null"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<DoctorDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func getListDepartments(completion:@escaping (String?, [DepartmentDataSource]?) -> Void) {
        
        let fullURLRequest = kGatewayOganizationURL + "/departments?sort[createdAt]=desc&filter[type][eq]=specialty&filter[deletedAt][isNull]=true&limit=10&offset=0"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<DepartmentDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
}
