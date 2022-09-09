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

class BookingServices : NSObject {
    public static let sharedInstance    = BookingServices()
    
    var selectedProfile                 = BehaviorRelay<EHealthDataSource?>(value: nil)
    var selectedDepartment              = BehaviorRelay<TeamDataSource?>(value: nil)
    var selectedOrganization            = BehaviorRelay<Organization?>(value: nil)
    var selectedDoctor                  = BehaviorRelay<DoctorDataSource?>(value: nil)
    var selectedTimeable                = BehaviorRelay<TimeableDataSource?>(value: nil)
    var bookingProduct                  = BehaviorRelay<ProductDataSource?>(value: nil)
    private let disposeBag              = DisposeBag()
    
    override init() {
        super.init()
        
        self.selectedDepartment
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.getListOrganization { _, listAttribute in
                    if let firstOrganization = listAttribute?.first {
                        self.selectedOrganization.accept(firstOrganization)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func cleanData() {
        selectedProfile.accept(nil)
        selectedDepartment.accept(nil)
        selectedOrganization.accept(nil)
        selectedDoctor.accept(nil)
        selectedTimeable.accept(nil)
        bookingProduct.accept(nil)
    }
    
    func getListDepartments(completion:@escaping (String?, [TeamDataSource]?) -> Void) {
        
        let param : [String:Any] = ["page" : 1,
                                    "offset": 0,
                                    "limit": 100,
                                    "filter[isDefault][eq]" : true,
                                    "filter[visibility][eq]" : true]
        let fullURLRequest = kGatewayOganizationURL + "/teams"
        _ = _AppDataHandler.get(parameters: param, fullURLRequest: fullURLRequest) { responseData in
                        
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
            completion("Required to select doctor", [])
            return
        }
        
        guard let selectedDepartmentID = self.selectedDepartment.value?.departmentID else {
            completion("Required to select department", [])
            return
        }

        let param : [String:Any] = ["filter[hostId][eq]" : selecteDoctorID,
                                    "filter[targetId][eq]" :selectedDepartmentID]
        
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
    
    func getListOrganization(completion:@escaping (String?, [Organization]?) -> Void) {
        
        guard let selectedOrganizationID = self.selectedDepartment.value?.department?.organizationId else {
            completion("Required to select department", [])
            return
        }
        
        let param : [String:Any] = ["filter[id][eq]": selectedOrganizationID]
        
        let fullURLRequest = kGatewayOganizationURL + "/organizations"
        _ = _AppDataHandler.get(parameters: param, fullURLRequest: fullURLRequest) { responseData in
                        
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<Organization>().mapArray(JSONArray: data))
                }
            }
        }
    }
    
    func getListBookings(_ filterStatus: String?, completion:@escaping (String?, [BookingAppointmentDataSource]?) -> Void) {
        var param : [String: Any] = ["sort[createdAt]": "desc"]
        if let filterStatus = filterStatus {
            param["filter[status][eq]"] = filterStatus
        }
        let fullURLRequest = kGatewayBookingURL + "/bookings"
        _ = _AppDataHandler.get(parameters: param, fullURLRequest: fullURLRequest) { responseData in
            
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, nil)
                return
            } else {
                
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    completion(responseData.responseMessage, Mapper<BookingAppointmentDataSource>().mapArray(JSONArray: data))
                    return
                }
                
                completion(responseData.responseMessage, nil)
            }
        }
    }
    
    func createBookingOrder(completion:@escaping (String?, String?) -> Void) {
        
        // productID of booking product
        guard let itemID = self.bookingProduct.value?.id else {
            completion("Not valid booking ID", nil)
            return
        }
        
        // timetableId
        guard let timetableId = self.selectedTimeable.value?.id else {
            completion("Not valid time block", nil)
            return
        }
        
        let params : [String: Any] = ["itemId" : itemID,
                                      "paymentMethodCode": "cards",
                                      "paymentPlatform": "web_browser",
                                      "timetableId":timetableId,
                                      "attributes":[]]
        let fullURLRequest = kGatewayBookingURL + "/bookings"
        
        _ = _AppDataHandler.post(parameters: params, fullURLRequest: fullURLRequest) { responseData in
            if responseData.responseCode == 200 {
                if let dataDict = responseData.responseData?["data"] as? [String: Any],
                let paymentData = dataDict["payment"]  as? [String: Any],
                   let metaData = paymentData["metadata"] as? [String: Any],
                   let clientSecret = metaData["clientSecret"] as? String {
                    completion(nil, clientSecret)
                    return
                }
                completion(responseData.responseMessage, nil)
            } else {
                completion(responseData.responseMessage, nil)
            }
        }
    }
}
