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
                        _NavController.showAlertConfirmation(NSLocalizedString("Error", comment: ""),
                                                 "Your internet connection not stable, please check again.",
                                                 "OK",
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
    
    private func handleResponseDict (response:AFDataResponse<Any>,
                                     requestParam: [String: Any]? = nil) -> ResponseDataSource? {
        if let urlRequest = response.request?.url?.path {
            bfprint("API-URL-Request: ", urlRequest)
        }
        
        if requestParam != nil {
            bfprint("API-Request-Param: ", requestParam!)
        }
        
        if let header = response.request?.allHTTPHeaderFields {
            bfprint("API-Header-Request: ", header)
        }
        
        var responseData = ResponseDataSource()
        responseData.responseCode = response.response?.statusCode ?? 0
        
        switch response.result {
        case .success(let value):
            
            print(String(format:"Lucas-API-Reponse: ", "Did get \(response.response!.statusCode) code"))
            if response.response!.statusCode < 300 {
                bfprint("Reponse-Success: ", "Did get \(response.response!.statusCode) success code")
                
            } else if response.response!.statusCode < 400 {
                bfprint("Reponse-Error: ", "Did get \(response.response!.statusCode) error code")
                
            }
            
            if responseData.responseCode == 200 ||
                responseData.responseCode == 204 ||
                responseData.responseCode == 400 {
                // Process to responseData
                if let responseDict = value as? [String: Any] {
                    responseData.responseData = responseDict
                }
                
                if let responseList = value as? [[String:Any]] {
                    responseData.responseList = responseList
                }
                
                if let responseDict = value as? [String: Any] {
                    responseData.responseMessage = responseDict["message"] as? String
                    responseData.responseErrorCode = responseDict["error"] as? String

                }
            } else if responseData.responseCode == 401 {
                DispatchQueue.main.async {
                    let alertVC = UIAlertController.init(title: NSLocalizedString("Authentication Error", comment: ""),
                                                         message: "User need to sign in again.\n(Error: 401)", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                        alertVC.dismiss()
                    }))
                    alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Sign out", comment: ""), style: .default, handler: { _ in
                        alertVC.dismiss()
                        _NavController.gotoLoginPage()
                    }))
                    _NavController.showAlert(alertVC)
                }
                return nil
            } else if responseData.responseCode == 403 {
                guard let responseDict = value as? [String: Any] else {
                    var tempResponse = ResponseDataSource.init()
                    tempResponse.responseMessage = "Phiên đăng nhập của bạn đã hết hạn, vui lòng đăng nhập lại."
                    return tempResponse
                }
                
                var tempResponse = ResponseDataSource.init()
                tempResponse.responseMessage = responseDict["error"] as? String
                return tempResponse
            } else if responseData.responseCode == 404 {
                bfprint("API NOT FOUND")
                return nil
            } else if responseData.responseCode >= 500 {
                
                responseData.responseMessage = NSLocalizedString("kServerErrorMessage", comment: "")
                if let responseDict = value as? [String: Any] {
                    responseData.responseMessage = responseDict["message"] as? String
                    responseData.responseErrorCode = responseDict["error"] as? String
                }
            } else {
                // Don't do anything
                bfprint(response.response as Any)
            }
            
        case .failure(let error):
            
//            responseData.responseMessage = error.localizedDescription
            
            if error._code == NSURLErrorCancelled {
                return nil
            } else if error.localizedDescription.contains("cancelled") {
                responseData.responseMessage = "kAPICanceled"// kAPICancelled
            } else if error._code == NSURLErrorNotConnectedToInternet {
                responseData.responseMessage = NSLocalizedString("kSorryErrorMessage", comment: "")
            } else if error._code == NSURLErrorTimedOut {
                responseData.responseCode = 500
            } else if error._code == NSURLErrorNetworkConnectionLost {
                responseData.responseCode = 500
            }
            
            bfprint(String(format:"Lucas API Response: %@", responseData.responseMessage ?? ""))
        }
        
        // Mapping Error code
        
        return responseData
    }
    
    func getHeadHeader() -> HTTPHeaders {
        
        guard let accessTk = _AppCoreData.userSession.value?.accessToken else {
            let header: HTTPHeaders = [:]
            return header
        }
        
        let headerFull: HTTPHeaders = ["Authorization": "Bearer " + accessTk,
                                       "x-tenant-id": "e2e050c2-a5cf-485b-b8b1-93b84de046e3",
                                       "internal-api-key": "token123"]
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
    
    func post(parameters: [String: Any]?, fullURLRequest: String, completion:@escaping (ResponseDataSource) -> Void) -> Request? {
        
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
    
    func put(parameters: [String: Any]?, fullURLRequest: String, completion:@escaping (ResponseDataSource) -> Void) -> Request? {
                
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
