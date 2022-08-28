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
import RxRelay
import RxSwift

@_exported import BugfenderSDK
class ApplicationCoreData: NSObject {
    
    public static let sharedInstance    = ApplicationCoreData()
    
    public var userSession             = BehaviorRelay<SessionDataSource?>(value: nil)
    public var userDataSource          = BehaviorRelay<UserDataSource?>(value: nil)
    private let disposeBag             = DisposeBag()
    
    private var timerRefeshToken: Timer?
    
    // MARK: - Initial
    override init() {
        super.init()
        self.initSync()
    }
    
    func startContext() {
        self.userSession
            .observe(on: MainScheduler.instance)
            .subscribe { userSession in
                self.syncDown()
            }
            .disposed(by: disposeBag)
        
        self.userDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { userDataSource in
                self.syncDown()
            }
            .disposed(by: disposeBag)
    }
    
    private class func getContext() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        return (delegate?.persistentContainer.viewContext)!
    }
    
    func signOut() {
        self.userSession.accept(nil)
        self.userDataSource.accept(nil)
        
        // Stop Refresh token
        self.timerRefeshToken?.invalidate()
        self.timerRefeshToken = nil
        
        self.syncDown()
    }
    
    // MARK: - CoreData
    private func initSync() {
        // Sync userSession
        if UserDefaults.standard.object(forKey: kUserSessionDataSource) is String {
            if let data = UserDefaults.standard.object(forKey: kUserSessionDataSource) as? String {
                let sessionData = SessionDataSource.init(JSONString: data)
                if sessionData != nil {
                    self.userSession.accept(sessionData)
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
                    self.userDataSource.accept(userData)
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
        if self.userSession.value == nil {
            UserDefaults.standard.removeObject(forKey: kUserSessionDataSource)
        } else {
            let data = self.userSession.value?.toJSONString()
            UserDefaults.standard.setValue(data, forKey: kUserSessionDataSource)
        }
        
        // Sync UserDataSource
        if self.userDataSource.value == nil {
            UserDefaults.standard.removeObject(forKey: kUserProfileDataSource)
        } else {
            let data = self.userDataSource.value?.toJSONString()
            UserDefaults.standard.setValue(data, forKey: kUserProfileDataSource)
        }
        
        if let userEmail = self.userDataSource.value?.userEmail {
            Bugfender.setDeviceString(userEmail, forKey: "user_Iden")
        }
    }
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: kAppAlreadyLaunchedOnce) {
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
