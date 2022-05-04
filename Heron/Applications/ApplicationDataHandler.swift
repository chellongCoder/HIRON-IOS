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
    
    private func handleResponseDict(response: AFDataResponse<Any>,
                                    requestParam: [String: Any]? = nil) -> ResponseDataSource?
    {
        
        if let urlRequest = response.request?.url?.path {
            bfprint(String(format: "Lucas-API-URL-Request: %@", urlRequest), tag: "API-Response", level: .default)
        }
        
        if requestParam != nil {
            bfprint(String(format: "Lucas-API-Request-Param: %@", requestParam!), tag: "API-Response", level: .default)
        }
        
        if let header = response.request?.allHTTPHeaderFields {
            bfprint(String(format: "Lucas-API-Header-Request: %@", header), tag: "API-Response", level: .default)
        }
        
        switch response.result {
            case .success(let value):
                
                if response.response!.statusCode < 300 {
                    bfprint(String(format:"Lucas-API-Reponse-Success: %@", "Did get \(response.response!.statusCode) success code"), tag: "API-Response", level: .default)
                    
                } else if response.response!.statusCode < 400 {
                    bfprint(String(format:"Lucas-API-Reponse-Error: %@", "Did get \(response.response!.statusCode) error code"), tag: "API-Response", level: .default)
                    
                } else if response.response!.statusCode < 500 {
                    bfprint(String(format:"Lucas-API-Reponse-Error: %@", "Did get \(response.response!.statusCode) error code"), tag: "API-Response", level: .default)
                    
                    if response.response!.statusCode == 401 {
                        // User expried token
                        _AppCoreData.signOut()
                        
                        return nil
                    } else if response.response!.statusCode == 403 {
                        // User expried token
                        
                        //                    self.reloadUserProfile()
                       // self.coreDataStored.signOut()
                        guard let responseDict = value as? [String: Any] else {
                            var tempResponse = ResponseDataSource.init(JSONString: "{}")!
                            tempResponse.errorMessage = "Phiên đăng nhập của bạn đã hết hạn, vui lòng đăng nhập lại."
                            return tempResponse
                        }
                        
                        var tempResponse = ResponseDataSource.init(JSONString: "{}")!
                        tempResponse.errorMessage = responseDict["error"] as? String
                        return tempResponse
                    }
                    
                } else if response.response!.statusCode < 600 {
                    bfprint(String(format:"Lucas-API-Reponse-Error: %@", "Did get \(response.response!.statusCode) error code"), tag: "API-Response", level: .default)
                    if response.response!.statusCode == 500 {
                        var tempResponse = ResponseDataSource.init(JSONString: "{}")!
                        tempResponse.errorMessage = NSLocalizedString("kServerErrorMessage", comment: "")
                        
                        return tempResponse
                    }
                }
                
                guard let responseDict = value as? [String: Any] else {
                    var tempResponse = ResponseDataSource.init(JSONString: "{}")!
                    tempResponse.errorMessage = NSLocalizedString("kAPIWrongFormatMessage", comment: "")
                    
                    return tempResponse
                }
                
                let finalResponse = Mapper<ResponseDataSource>().map(JSON: responseDict)
                
                bfprint(String(format:"Lucas-API-Reponse-Error: %@", finalResponse?.toJSONString() ?? ""), tag: "API-Response", level: .default)
                
                return finalResponse
                
            case .failure(let error):
                
                
                
                var failResponse = ResponseDataSource.init(JSONString: "{}")!
                failResponse.errorMessage = error.localizedDescription
                
                if error._code == 13 {
                    failResponse.errorMessage = "Internet không ổn định vui lòng kiểm tra lại"
                    return failResponse
                }
                
                //            if error._code == NSURLErrorTimedOut {
                //                failResponse.errorMessage = NSLocalizedString("kAPIErrorTimeOut", comment: "")
                //            }
                if error._code == NSURLErrorCancelled {
                    failResponse.errorMessage = "kAPICanceled"// kAPICancelled
                } else if error.localizedDescription.contains("cancelled") {
                    failResponse.errorMessage = "kAPICanceled"// kAPICancelled
                } else if error._code == NSURLErrorNotConnectedToInternet {
                    failResponse.errorMessage = NSLocalizedString("kSorryErrorMessage", comment: "")
                }
                //            else if error._code == NSURLErrorCannotParseResponse {
                //                failResponse.errorMessage = NSLocalizedString("kAPIFailToParse", comment: "")
                //            }
                //            else if ((failResponse.errorMessage?.contains("JSON could not be serialized because of error")) != nil) {
                //                failResponse.errorMessage = NSLocalizedString("kAPIFailToParse", comment: "")
                //            }
                
                bfprint(String(format:"Lucas API Response: %@", failResponse.toJSONString() ?? ""), tag: "API-Response", level: .default)
                //            #else
                //            bfprint("API Request:", Date(), failResponse.toJSONString() ?? "", to: &ConsoleLog.consoleLog)
                
                return failResponse
        }
    }
    
    func getHeadHeader(_ accessToken: String?) -> HTTPHeaders {
        
        guard let accessTk = accessToken else {
            let header: HTTPHeaders = [:]
            return header 
        }
        
        let headerFull: HTTPHeaders = ["Authorization": "Bearer " + accessTk]
        return headerFull
    }
    
    func refreshToken(completion:@escaping (Bool, String?)-> Void) -> Request? {
        
        guard let refreshToken = _AppCoreData.getUserSession()?.refreshToken else {
            completion(false, NSLocalizedString("kAPIRequestLogin", comment: ""))
            return nil
        }
        
        let parametter = ["refreshToken": refreshToken]
        
        return self.alamofireManager.request(kGatewayUserBaseURL+"/auth/refresh-token",
                                             method: .post,
                                             parameters: parametter,
                                             encoding: JSONEncoding.default,
                                             headers: nil)
            .responseJSON { (response: AFDataResponse<Any>) in
                
                guard let responseData = self.handleResponseDict(response: response) else {
                    completion(false, NSLocalizedString("kAPIWrongFormatMessage", comment: ""))
                    return
                }
                if responseData.errorMessage == "kAPICanceled" {
                    return
                }
                
                if let responseDict = responseData.objectData {
                    let sessionToken = SessionDataSource.init(JSONString: "{}")!
                    if let accessToken = responseDict["accessToken"] as? String {
                        sessionToken.accessToken = accessToken
                    }
                    if let refreshToken = responseDict["refreshToken"] as? String {
                        sessionToken.refreshToken = refreshToken
                    }
                    
                    _AppCoreData.setUserSession(sessionToken)
                    
                    completion(true, responseData.successMessage)
                } else {
                    completion(false, responseData.errorMessage)
                }
            }
    }
    
    func getUserNotificationCount(completion:@escaping (Bool, String?, Int)-> Void) -> Request? {
        guard let accessToken = _AppCoreData.getUserSession()?.accessToken else {
            completion(false, NSLocalizedString("kAPIRequestLogin", comment: ""), 0)
            return nil
        }
        
        bfprint(String(format:"Lucas-API-Request-URL: %@", kGatewayUserBaseURL+"/notifications/unread/count"), tag: "API-Request", level: .default)
        
        let request = self.alamofireManager.request(kGatewayUserBaseURL+"/notifications/unread/count",
                                                    method: .get,
                                                    parameters: nil,
                                                    encoding: URLEncoding.default,
                                                    headers: getHeadHeader(accessToken))
            .responseJSON { (response: AFDataResponse<Any>) in
                
                guard let responseData = self.handleResponseDict(response: response) else {
                    completion(false, NSLocalizedString("kAPIWrongFormatMessage", comment: ""), 0)
                    return
                }
                
                if responseData.errorMessage != nil {
                    
                    if responseData.errorMessage == "kAPICanceled" {
                        return
                    }
                    
                    completion(false, responseData.errorMessage, 0)
                    return
                }
                
                if let count = responseData.objectData?["unRead"] as? Int {
                    UIApplication.shared.applicationIconBadgeNumber = count
                    completion(true, responseData.successMessage, count)
                    return
                } else {
                    completion(true, responseData.successMessage, 0)
                }
            }
        return request
    }
    
    func getUserDataSource(completion:@escaping (Bool, String?, UserDataSource?)-> Void) -> Request? {
        
        guard let accessToken = _AppCoreData.getUserSession()?.accessToken else {
            completion(false, NSLocalizedString("kAPIRequestLogin", comment: ""), nil)
            return nil
        }
        
        bfprint(String(format:"Lucas-API-Request-URL: %@", kGatewayUserBaseURL+"/user/profile"), tag: "API-Request", level: .default)
        
        return self.alamofireManager.request(kGatewayUserBaseURL+"/user/profile",
                                             method: .get,
                                             parameters: nil,
                                             encoding: JSONEncoding.default,
                                             headers: getHeadHeader(accessToken))
            .responseJSON { (response: AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    completion(false, NSLocalizedString("kAPIWrongFormatMessage", comment: ""), nil)
                    return
                }
                
                if responseData.errorMessage == "kAPICanceled" {
                    return
                }
                
                if let responseDict = responseData.objectData {
                    
                    let userData = Mapper<UserDataSource>().map(JSONObject: responseDict)!
                    _AppCoreData.setUserDataSource(userData)
                    
                    completion(true, "", userData)
                    
                } else {
                    completion(false, responseData.errorMessage, nil)
                }
            }
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
    func getNewestVersion(completion:@escaping (Bool, String?, String?)-> Void) -> Request? {
        
        bfprint(String(format:"Lucas-API-Request-URL: %@", kGatewayUserBaseURL + "/versions"), tag: "API-Request", level: .default)
        
        let request = self.alamofireManager.request(kGatewayUserBaseURL + "/versions",
                                                    method: .get,
                                                    parameters: nil,
                                                    encoding: URLEncoding.default,
                                                    headers: nil)
            .responseJSON { (response: AFDataResponse<Any>) in
                
                guard let responseData = self.handleResponseDict(response: response) else {
                    completion(false, NSLocalizedString("kAPIWrongFormatMessage", comment: ""), nil)
                    return
                }
                
                if responseData.errorMessage != nil {
                    if responseData.errorMessage == "kAPICanceled" {
                        return
                    }
                    
                    completion(false, responseData.errorMessage, nil)
                    return
                }
                
                if responseData.objectList.count == 0 {
                    completion(true, responseData.successMessage, nil)
                    return
                } else {
                    let returnArray = Mapper<AppVersionDataSource>().mapArray(JSONArray: responseData.objectList)
                    var minimumVersion = "1.0.0"
                    
                    for versionData in returnArray {
                        if versionData.platform == "iOS_DanhY" {
                            minimumVersion = versionData.minimumVersion ?? "1.0.0"
                            break
                        }
                    }
                    
                    completion(true, responseData.successMessage, minimumVersion)
                }
            }
        return request
    }
    
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
