//
//  UserServices.swift
//  Heron
//
//  Created by Luu Luc on 16/08/2022.
//

import UIKit
import ObjectMapper

class UserServices {
    public static let sharedInstance = UserServices()
    
    func getUserProfile() {
        let fullURLRequest = kGatewayUserServicesURL + "/users/profile"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
            if let data = responseData.responseData?["data"] as? [String:Any] {
                if let newUserData = Mapper<UserDataSource>().map(JSON: data) {
                    _AppCoreData.setUserDataSource(newUserData)
                    _CheckoutServices.billingAddress.accept(newUserData)
                }
            }
        }
    }
}