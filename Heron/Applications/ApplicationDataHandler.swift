//
//  ApplicationDataHandler.swift
//  Heron
//
//  Created by Luu Lucas on 9/23/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import Alamofire
import OneSignal
import ObjectMapper

@_exported import BugfenderSDK

class ApplicationDataHandler: NSObject {
    
    public static let sharedInstance    = ApplicationDataHandler()
    
    // Alarmofire
    var alamofireManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        configuration.sessionSendsLaunchEvents = false
        let alamofire = Alamofire.Session(configuration: configuration, startRequestsImmediately: true)
        return alamofire
    }()
    
    override init() {
        super.init()
    }
    
    // Utils
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func checkConnectionRepeatedly() {
        DispatchQueue.global(qos: .background).async {
            let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                if !self.isConnectedToInternet() {
                    DispatchQueue.main.async {
                        _NavController.showAlertConfirmation(NSLocalizedString("kAlertTitle", comment: ""),
                                                 "Kết nối internet của bạn không ổn định, vui lòng kiểm tra lại.",
                                                 NSLocalizedString("kOkAction", comment: ""),
                                                 "Settings") {
                            self.checkConnectionRepeatedly()
                        } failureCompletion: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                if UIApplication.shared.canOpenURL(url) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                            self.checkConnectionRepeatedly()
                        }
                    }
                    timer.invalidate()
                } else {
                    NotificationCenter.default.post(name: kInternetNotificationAlive, object: nil)
                }
            }
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: .default)
            runLoop.run()
        }
    }
}

//MARK: -
extension ApplicationDataHandler {
    
    // MARK: - Helper
    
    private func handleResponseDict (response:AFDataResponse<Any>) -> ResponseDataSource?
    {
        if let urlRequest = response.request?.url?.path {
            print(String(format: "Lucas-API-URL-Request: %@", urlRequest))
        }
        
        if let header = response.request?.allHTTPHeaderFields {
            print(String(format: "Lucas-API-Header-Request: %@", header))
        }
        
        var responseData = ResponseDataSource()
        responseData.responseCode = response.response?.statusCode ?? 0
        
        switch response.result {
        case .success(let value):
            
            print(String(format:"Lucas-API-Reponse: %@", "Did get \(response.response!.statusCode) code"))
            if responseData.responseCode == 200 ||
                responseData.responseCode == 204 ||
                responseData.responseCode == 400
            {
                // Process to responseData
                if let responseDict = value as? [String: Any] {
                    responseData.responseData = responseDict
                }
                
                if let responseList = value as? [[String:Any]] {
                    responseData.responseList = responseList
                }
                
                if let responseDict = value as? [String: Any] {
                    responseData.responseMessage = responseDict["message"] as? String
                }
            }
            else if responseData.responseCode == 401 ||
                        responseData.responseCode == 403
            {
                if (response.request?.url?.path ?? "").contains("system/session") {
                    
                    // ignored case signout with 401
                    return nil
                }
                return nil
            }
            else if responseData.responseCode == 404 {
                print("API NOT FOUND")
                return nil
            }
            else if responseData.responseCode >= 500 {
                
                responseData.responseMessage = NSLocalizedString("kServerErrorMessage", comment: "")
                
                if let responseDict = value as? [String: Any] {
                    responseData.responseMessage = responseDict["message"] as? String
                }
            }
            else {
                // Don't do anything
                print(response.response as Any)
            }
            
        case .failure(let error):
            
//            responseData.responseMessage = error.localizedDescription
            
            if error._code == NSURLErrorCancelled {
                responseData.responseMessage = "kAPICanceled"// kAPICancelled
            } else if error.localizedDescription.contains("cancelled") {
                responseData.responseMessage = "kAPICanceled"// kAPICancelled
            } else if error._code == NSURLErrorNotConnectedToInternet {
                responseData.responseMessage = NSLocalizedString("kSorryErrorMessage", comment: "")
            } else if error._code == NSURLErrorTimedOut {
                responseData.responseCode = 500
            } else if error._code == NSURLErrorNetworkConnectionLost {
                responseData.responseCode = 500
            }
            
            print(String(format:"Lucas API Response: %@", responseData.responseMessage ?? ""))
        }
        
        return responseData
    }
    
    func getHeadHeader(_ accessToken: String?) -> HTTPHeaders {
        
        guard let accessTk = accessToken else {
            let header: HTTPHeaders = [:]
            return header 
        }
        
        let headerFull: HTTPHeaders = ["Authorization": "Bearer " + accessTk]
        return headerFull
    }
}

// MARK: - OneSignal Push Notification
extension ApplicationDataHandler {
    ////Call this func after logout success
    public func removeExternalUserId() {
        OneSignal.removeExternalUserId({ results in
            guard let results = results else {return}
            bfprint("OneSignal.removeExternalUserId", results)
        })
    }
    
    //// Call this function after received login response
    public func setExternalUserId(id: String) {
        OneSignal.setExternalUserId(id) { (results) in
            guard let results = results else {return}
            bfprint("OneSignal.setExternalUserId Success", results)
        } withFailure: { (error) in
            bfprint("OneSignal.setExternalUserId Fail", error?.localizedDescription ?? "")
        }
    }
}


// MARK: - App Version
extension ApplicationDataHandler {
    
    func isUpdateAvailable(callback: @escaping (Bool) -> Void) {
        let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        
        bfprint(String(format:"Lucas-API-Request-URL: %@", "https://itunes.apple.com/lookup?bundleId=\(bundleId)"), tag: "API-Request", level: .default)
        
        self.alamofireManager.request("https://itunes.apple.com/lookup?bundleId=\(bundleId)").responseJSON { response in
            if let json = response.value as? NSDictionary,
               let results = json["results"] as? NSArray,
               let entry = results.firstObject as? NSDictionary,
               let versionStore = entry["version"] as? String,
               let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                
                if ourVersion.compare(versionStore, options: .numeric) == .orderedAscending {
                    callback(true)
                }
            }
            callback(false) // no new version or failed to fetch app store version
        }
    }
}

//MARK: - Authentications
extension ApplicationDataHandler {
    
    func login(completion:@escaping (String?, String?)-> Void) -> Request? {
                
        let parametter = ["username": "administrator",
                          "password": "super_admin@123./"]
        
        bfprint(String(format:"Lucas-API-Request-URL: %@", kGatewayAuthenticationURL+"/auth/login/phone"), tag: "API-Request", level: .default)
        bfprint(String(format:"Lucas-API-Request-Param: %@", parametter), tag: "API-Request", level: .default)
        
        return self.alamofireManager.request(kGatewayAuthenticationURL+"/authentication/login",
                                             method: .post,
                                             parameters: parametter,
                                             encoding: JSONEncoding.default,
                                             headers: getHeadHeader(nil))
            .responseJSON { (response: AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    completion(NSLocalizedString("kAPIWrongFormatMessage", comment: ""), nil )
                    return
                }
                
                if responseData.responseMessage == "kAPICanceled" {
                    return
                }
                
                if let responseDict = responseData.responseData {
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

//MARK: - Inventory
extension ApplicationDataHandler {
    
    func getListProducts(completion:@escaping (String?, [ProductDataSource]?)-> Void) {
        
        let param : [String:Any] = [:]
        
        self.alamofireManager.request(kGatwayInventoryURL + "/products",
                                      method: .get,
                                      parameters: param,
                                      encoding: URLEncoding.default,
                                      headers: self.getHeadHeader(nil))
            .responseJSON { (response:AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    completion(nil, nil)
                    return
                }
                
                if (responseData.responseMessage != nil) && (responseData.responseMessage == "kAPICanceled") {
                    completion(nil, nil)
                    return
                }
                else if responseData.responseCode == 400 {
                    completion(responseData.responseMessage, nil)
                    return
                }
                else if responseData.responseCode >= 500 {
                    return
                } else {
                    
                    #warning("API_NEED_MAINTAIN")
                    // API response array nhưng lại kẹp trong data.
                    
                    if let data = responseData.responseData?["data"] as? [[String:Any]] {
                        completion(responseData.responseMessage,
                                   Mapper<ProductDataSource>().mapArray(JSONArray: data))
                    }
                }
            }
    }
}
