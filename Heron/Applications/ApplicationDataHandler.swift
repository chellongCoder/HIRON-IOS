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

// MARK: -
extension ApplicationDataHandler {
    
    // MARK: - Helper
    
    private func handleResponseDict (response:AFDataResponse<Any>) -> ResponseDataSource? {
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
            } else if responseData.responseCode == 401 || responseData.responseCode == 403 {
                if (response.request?.url?.path ?? "").contains("system/session") {
                    
                    // ignored case signout with 401
                    return nil
                }
                return nil
            } else if responseData.responseCode == 404 {
                print("API NOT FOUND")
                return nil
            } else if responseData.responseCode >= 500 {
                
                responseData.responseMessage = NSLocalizedString("kServerErrorMessage", comment: "")
                
                if let responseDict = value as? [String: Any] {
                    responseData.responseMessage = responseDict["message"] as? String
                }
            } else {
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
    
    func getHeadHeader() -> HTTPHeaders {
        
        guard let accessTk = _AppCoreData.getUserSession()?.accessToken else {
            let header: HTTPHeaders = [:]
            return header
        }
        
        let headerFull: HTTPHeaders = ["Authorization": "Bearer " + accessTk]
        return headerFull
    }
}

// MARK: - App Version
extension ApplicationDataHandler {
    
    func isUpdateAvailable(callback: @escaping (Bool) -> Void) {
        let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String
        
        bfprint(String(format:"Lucas-API-Request-URL: %@", "https://itunes.apple.com/lookup?bundleId=\(bundleId ?? "")"), tag: "API-Request", level: .default)
        
        self.alamofireManager.request("https://itunes.apple.com/lookup?bundleId=\(bundleId ?? "")").responseJSON { response in
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

// MARK: - POST API template request
extension ApplicationDataHandler {
    func get(parameters: [String: Any]?, fullURLRequest: String, completion:@escaping (ResponseDataSource) -> Void) -> Request? {
                
        bfprint(String(format:"Lucas-API-Request-URL: %@", fullURLRequest), tag: "API-Request", level: .default)
        bfprint(String(format:"Lucas-API-Request-Param: %@", parameters ?? "nil"), tag: "API-Request", level: .default)
        
        return self.alamofireManager.request(fullURLRequest,
                                             method: .get,
                                             parameters: parameters,
                                             encoding: URLEncoding.default,
                                             headers: getHeadHeader())
            .responseJSON { (response: AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    return
                }
                
                if responseData.responseMessage == "kAPICanceled" {
                    return
                }
                
                completion(responseData)
            }
    }
    
    func post(parameters: [String: Any]?, fullURLRequest: String, completion:@escaping (ResponseDataSource) -> Void) -> Request?
    {
                
        bfprint(String(format:"Lucas-API-Request-URL: %@", fullURLRequest), tag: "API-Request", level: .default)
        bfprint(String(format:"Lucas-API-Request-Param: %@", parameters ?? "nil"), tag: "API-Request", level: .default)
        
        return self.alamofireManager.request(fullURLRequest,
                                             method: .post,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default,
                                             headers: getHeadHeader())
            .responseJSON { (response: AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    return
                }
                
                if responseData.responseMessage == "kAPICanceled" {
                    return
                }
                
                completion(responseData)
            }
    }
    
    func put(parameters: [String: Any]?, fullURLRequest: String, completion:@escaping (ResponseDataSource) -> Void) -> Request?
    {
                
        bfprint(String(format:"Lucas-API-Request-URL: %@", fullURLRequest), tag: "API-Request", level: .default)
        bfprint(String(format:"Lucas-API-Request-Param: %@", parameters ?? "nil"), tag: "API-Request", level: .default)
        
        return self.alamofireManager.request(fullURLRequest,
                                             method: .put,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default,
                                             headers: getHeadHeader())
            .responseJSON { (response: AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    return
                }
                
                if responseData.responseMessage == "kAPICanceled" {
                    return
                }
                
                completion(responseData)
            }
    }
    
    func delete(parameters: [String: Any]?, fullURLRequest: String, completion:@escaping (ResponseDataSource) -> Void) -> Request? {
        bfprint(String(format:"Lucas-API-Request-URL: %@", fullURLRequest), tag: "API-Request", level: .default)
        bfprint(String(format:"Lucas-API-Request-Param: %@", parameters ?? "nil"), tag: "API-Request", level: .default)
        
        return self.alamofireManager.request(fullURLRequest,
                                             method: .delete,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default,
                                             headers: getHeadHeader())
            .responseJSON { (response: AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    return
                }
                
                if responseData.responseMessage == "kAPICanceled" {
                    return
                }
                
                completion(responseData)
            }
    }
    
    func patch(parameters: [String: Any]?, fullURLRequest: String, completion:@escaping (ResponseDataSource) -> Void) -> Request? {
                
        bfprint(String(format:"Lucas-API-Request-URL: %@", fullURLRequest), tag: "API-Request", level: .default)
        bfprint(String(format:"Lucas-API-Request-Param: %@", parameters ?? "nil"), tag: "API-Request", level: .default)
        
        return self.alamofireManager.request(fullURLRequest,
                                             method: .patch,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default,
                                             headers: getHeadHeader())
            .responseJSON { (response: AFDataResponse<Any>) in
                guard let responseData = self.handleResponseDict(response: response) else {
                    return
                }
                
                if responseData.responseMessage == "kAPICanceled" {
                    return
                }
                
                completion(responseData)
            }
    }
}
