//
//  ApplicationCoreData.swift
//  Heron
//
//  Created by Luu Lucas on 9/23/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import ObjectMapper

@_exported import BugfenderSDK
class ApplicationCoreData: NSObject {
    
    public static let sharedInstance    = ApplicationCoreData()
    
    private var userSession: SessionDataSource?
    private var userDataSource: UserDataSource?
    
    private var timerRefeshToken: Timer?
    
    // MARK: - Initial
    override init() {
        super.init()
        self.initSync()
    }
    
    func startContext() {
        
    }
    
    private func refreshUserDataCache() {
        if let countRefresh = UserDefaults.standard.value(forKey: kAppRefreshUserDataCacheTime) as? Int {
            let currentTime = Int(Date().timeIntervalSince1970)
            
            if currentTime < countRefresh + kAppRefresTime {
                return
            }
        }
        
        UserDefaults.standard.setValue(Int(Date().timeIntervalSince1970), forKey: kAppRefreshUserDataCacheTime)
    }
    
    
    private class func getContext() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        return (delegate?.persistentContainer.viewContext)!
    }
    
    // MARK: - Getter
    func getUserSession() -> SessionDataSource? {
        return self.userSession
    }
    
    func getUserDataSource() -> UserDataSource? {
        //request refresh cache if need
        refreshUserDataCache()
        
        return self.userDataSource
    }
    
    // MARK: Setter
    func setUserSession(_ newUserSession: SessionDataSource) {
        self.userSession = newUserSession
        self.refreshTokenActive()
        self.syncDown()
    }
    
    func setUserDataSource(_ newUserDataSource: UserDataSource) {
        self.userDataSource = newUserDataSource
        self.syncDown()
        
        // OneSignal config
        if let userID = self.userDataSource?.userID {
            if !userID.isEmpty {
                _AppDataHandler.setExternalUserId(id: userID)
            }
        }
        
        if let userEmail = self.userDataSource?.userEmail {
            Bugfender.setDeviceString(userEmail, forKey: "user_Iden")
        }

        NotificationCenter.default.post(name: kUserLoggedInNotification, object: nil)
    }
    
    func signOut() {
        self.userSession = nil
        self.userDataSource = nil
        // OneSignal config
        _AppDataHandler.removeExternalUserId()
        
        // Stop Refresh token
        self.timerRefeshToken?.invalidate()
        self.timerRefeshToken = nil
        
        self.syncDown()
        NotificationCenter.default.post(name: kUserSignOutNotification, object: nil)
    }
    
    // MARK: - CoreData
    private func initSync() {
        // Sync userSession
        if UserDefaults.standard.object(forKey: kUserSessionDataSource) is String {
            if let data = UserDefaults.standard.object(forKey: kUserSessionDataSource) as? String {
                let sessionData = SessionDataSource.init(JSONString: data)
                if sessionData != nil {
                    self.userSession = sessionData
                } else {
                    UserDefaults.standard.removeObject(forKey: kUserSessionDataSource)
                }
            }
        } else {
            UserDefaults.standard.removeObject(forKey: kUserSessionDataSource)
        }
        
        // sync userDataSource
        if UserDefaults.standard.object(forKey: kUserProfileDataSource) is String {
            if let data = UserDefaults.standard.object(forKey: kUserProfileDataSource) as? String {
                let userData = UserDataSource.init(JSONString: data)
                if userData != nil {
                    self.userDataSource = userData
                } else {
                    UserDefaults.standard.removeObject(forKey: kUserProfileDataSource)
                }
            }
        } else {
            UserDefaults.standard.removeObject(forKey: kUserProfileDataSource)
        }
    }
    
    private func syncDown() {
        // Sync SessionDataSource
        if self.userSession == nil {
            UserDefaults.standard.removeObject(forKey: kUserSessionDataSource)
        } else {
            let data = self.userSession?.toJSONString()
            UserDefaults.standard.setValue(data, forKey: kUserSessionDataSource)
        }
        
        // Sync UserDataSource
        if self.userDataSource == nil {
            UserDefaults.standard.removeObject(forKey: kUserProfileDataSource)
        } else {
            let data = self.userDataSource?.toJSONString()
            UserDefaults.standard.setValue(data, forKey: kUserProfileDataSource)
        }
    }
    
    func isAppAlreadyLaunchedOnce() -> Bool{
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: kAppAlreadyLaunchedOnce){
            return true
        } else {
            defaults.set(true, forKey: kAppAlreadyLaunchedOnce)
            return false
        }
    }
}

extension NSManagedObject {
    func toJSONString() -> String? {
        
        let keys = Array(self.entity.attributesByName.keys)
        let dict = self.dictionaryWithValues(forKeys: keys)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            return reqJSONStr
        } catch {}
        return nil
    }
}

extension ApplicationCoreData {
    func refreshTokenActive() {
        self.timerRefeshToken?.invalidate()
        self.timerRefeshToken = nil
        self.timerRefeshToken = Timer.scheduledTimer(timeInterval: 10*60,
                                                     target: self,
                                                     selector: #selector(processRefreshToken),
                                                     userInfo: nil,
                                                     repeats: true)
    }
    
    @objc private func processRefreshToken() {
//        _ =  _AppDataHandler.refreshToken {(isSuccess, _) in
//            
//            if isSuccess {
//                print("success refreshToken")
//            } else {
//                print("fail refreshToken")
//            }
//        }
    }
}
