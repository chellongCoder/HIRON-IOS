//
//  AuthenticationServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

class AuthenticationServices {
    
    public static let sharedInstance = AuthenticationServices()

    func login(username: String, password: String, completion:@escaping (String?, String?) -> Void) {
                
        let parametter = ["username": username,
                          "password": password]
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
                
                _AppCoreData.userSession.accept(sessionToken)
                _UserServices.getUserProfile()
                
                completion(nil, responseData.responseMessage)
            } else {
                completion(responseData.responseMessage, nil)
            }
        }
    }
    
    func checkExist(username: String, password: String, completion:@escaping (String?, String?) -> Void) {
        let parametter = ["username": username,
                          "password": password]
        let fullURLRequest = kGatewayAuthenticationURL+"/users/check-exist"
        
        _ = _AppDataHandler.post(parameters: parametter, fullURLRequest: fullURLRequest) { responseData in
            if let responseDict = responseData.responseData?["data"] as? [String : Any] {
                let sessionToken = SessionDataSource.init(JSONString: "{}")!
                if let accessToken = responseDict["accessToken"] as? String {
                    sessionToken.accessToken = accessToken
                }
                if let refreshToken = responseDict["refreshToken"] as? String {
                    sessionToken.refreshToken = refreshToken
                }
                
                _AppCoreData.userSession.accept(sessionToken)
                completion(nil, responseData.responseMessage)
            } else {
                completion(responseData.responseMessage, nil)
            }
        }
    }
    
    func signUp(userInfo: UserDataSource, completion:@escaping (String?, String?) -> Void) {
        let fullURLRequest = "https://ehp-api.cbidigital.com/user-svc/api/users/register"
        
        _ = _AppDataHandler.post(parameters: userInfo.toJSON(), fullURLRequest: fullURLRequest) { responseData in
            if let responseDict = responseData.responseData?["data"] as? [String : Any] {
                let sessionToken = SessionDataSource.init(JSONString: "{}")!
                if let accessToken = responseDict["accessToken"] as? String {
                    sessionToken.accessToken = accessToken
                }
                if let refreshToken = responseDict["refreshToken"] as? String {
                    sessionToken.refreshToken = refreshToken
                }
                
                _AppCoreData.userSession.accept(sessionToken)
                
                completion(nil, responseData.responseMessage)
            } else {
                completion(responseData.responseMessage, nil)
            }
        }
    }
}
