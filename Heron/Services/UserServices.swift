//
//  UserServices.swift
//  Heron
//
//  Created by Luu Luc on 16/08/2022.
//

import UIKit
import ObjectMapper
import RxSwift

class UserServices : NSObject {
    public static let sharedInstance = UserServices()
    private let disposeBag           = DisposeBag()
    
    override init() {
        super.init()
        _AppCoreData.userSession
            .observe(on: MainScheduler.instance)
            .subscribe { newSessionData in
                guard let newSessionData = newSessionData.element else { return }
                guard let newToken = newSessionData?.accessToken else { return }
                self.getUserProfile()
            }
            .disposed(by: disposeBag)

    }
    
    func getUserProfile() {
        let fullURLRequest = kGatewayUserServicesURL + "/users/profile"
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
            if let data = responseData.responseData?["data"] as? [String:Any] {
                if let newUserData = Mapper<UserDataSource>().map(JSON: data) {
                    _AppCoreData.userDataSource.accept(newUserData)
                    _CheckoutServices.billingAddress.accept(newUserData)
                }
            }
        }
    }
    
    func updateUserProfile(_ newUserProfile: UserDataSource, completion:@escaping (String?, Bool) -> Void) {
        let fullURLRequest = kGatewayUserServicesURL + "/users/profile"
        _ = _AppDataHandler.patch(parameters: newUserProfile.toJSON(), fullURLRequest: fullURLRequest, completion: { responseData in
            if responseData.responseCode == 204 {
                completion(nil, true)
            } else {
                completion(responseData.responseMessage, false)
            }
        })
    }
}
