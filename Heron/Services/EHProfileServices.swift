//
//  EHProfileServices.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit
import RxRelay
import ObjectMapper
import RxCocoa

class EHProfileServices: NSObject {
    public static let sharedInstance    = EHProfileServices()
    var listProfiles        = BehaviorRelay<[EHealthDataSource]>(value: [])

    override init() {
        super.init()
        self.getListEHProfile { errorMessage in
            print("Get list profile error: %@", errorMessage ?? "")
        }
    }
    
    func cleanData() {
        self.listProfiles.accept([])
    }
    
    func getListEHProfile(completion:@escaping (String?) -> Void) {
        
        let fullURLRequest = kGatewayEHealthProfileURL + "/profiles?filter[typeId][eq]=null"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage)
                return
            } else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    let listEHealthProfiles = Mapper<EHealthDataSource>().mapArray(JSONArray: data)
                    self.listProfiles.accept(listEHealthProfiles)
                    _BookingServices.selectedProfile.accept(listEHealthProfiles.first)
                    completion(nil)
                }
            }
        }
    }
    
    func updateEHProfile(_ ehProfile: EHealthDataSource, completion:@escaping (String?, String?) -> Void) {
        
        let fullURLRequest = kGatewayEHealthProfileURL + "/profiles/" + ehProfile.id
        
        _ = _AppDataHandler.patch(parameters: ehProfile.toJSON(), fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            } else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [String:Any] {
                    if let updatedEHProfile = Mapper<EHealthDataSource>().map(JSON: data) {
                        self.listProfiles.accept([updatedEHProfile])
                        _BookingServices.selectedProfile.accept(updatedEHProfile)
                        completion(nil, nil)
                    }
                }
            }
        }
    }
}
