//
//  AuthenticationServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

class AuthenticationServices {
    
    public static let sharedInstance = AuthenticationServices()

    func login(completion:@escaping (String?, String?)-> Void) {
                
        let parametter = ["username": "administrator",
                          "password": "super_admin@123./"]
        let fullURLRequest = kGatewayAuthenticationURL+"/authentication/login"
        
        _ = _AppDataHandler.post(parameters: parametter, fullURLRequest: fullURLRequest) { responseData in
            if let responseDict = responseData.responseData?["data"] as? [String : Any] {
                let sessionToken = SessionDataSource.init(JSONString: "{}")!
                if let accessToken = responseDict["accessToken"] as? String {
                    sessionToken.accessToken = accessToken
                }
                if let refreshToken = responseDict["refreshToken"] as? String {
                    sessionToken.refreshToken = refreshToken
                }
                
                _AppCoreData.setUserSession(sessionToken)
                
                completion(nil, responseData.responseMessage)
            } else {
                completion(responseData.responseMessage, nil)
            }
        }
    }
}
