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
    var selectedDepartment              = BehaviorRelay<TeamDataSource?>(value: nil)
    var selectedDoctor                  = BehaviorRelay<DoctorDataSource?>(value: nil)
    var selectedTimeable                = BehaviorRelay<TimeableDataSource?>(value: nil)
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
    
    func getListDepartments(completion:@escaping (String?, [TeamDataSource]?) -> Void) {
        
        let fullURLRequest = kGatewayOganizationURL + "/teams"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    let listDepartments = Mapper<TeamDataSource>().mapArray(JSONArray: data)
                    let filteredDepartment = listDepartments.filter { teamData in
                        return teamData.isDefault == true
                    }
                    completion(responseData.responseMessage, filteredDepartment)
                }
            }
        }
    }
    
    func getListDoctors(completion:@escaping (String?, [DoctorDataSource]?) -> Void) {
        
        guard let selectedDepartmentID = self.selectedDepartment.value?.departmentID else {
            completion("Required to select department", [])
            return
        }
        
        let param : [String:Any] = ["page" : 1,
                                    "offset": 0,
                                    "limit": 100,
                                    "sort[createdAt]":"desc",
                                    "filter[type][eq]":"doctor",
                                    "filter[deletedAt][eq]":"null",
                                    "filter[teamMemberPosition][team][departmentId][eq]": selectedDepartmentID]
        
        let fullURLRequest = kGatewayOganizationURL + "/members"
        _ = _AppDataHandler.get(parameters: param, fullURLRequest: fullURLRequest) { responseData in
                        
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
    
    func getListTimeables(completion:@escaping (String?, [TimeableDataSource]?) -> Void) {
        
        guard let selecteDoctorID = self.selectedDoctor.value?.id else {
            completion("Required to select department", [])
            return
        }

        let param : [String:Any] = ["filter[hostId][eq]":selecteDoctorID]
        
        let fullURLRequest = kGatewayBookingURL + "/timetable"
        _ = _AppDataHandler.get(parameters: param, fullURLRequest: fullURLRequest) { responseData in
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<TimeableDataSource>().mapArray(JSONArray: data))
                }
            }
        }
    }
}