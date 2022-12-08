//
//  AppDelegate.swift
//  Heron
//
//  Created by Luu Luc on 21/11/2021.
//

import UIKit
import CoreData
import IQKeyboardManager
import BugfenderSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // swiftlint:disable force_cast 
    static let sharedInstance       = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initServices()
        
        ApplicationTracking.shareInstance.commonConfig()
        _AppDataHandler.checkConnectionRepeatedly()
        IQKeyboardManager.shared().isEnabled = true
        
        // MARK: Tracking
        Bugfender.activateLogger("PobpLgnctGQTDDJAGhLAJsyDNS8okX5A")
        Bugfender.enableCrashReporting()
//        Bugfender.enableUIEventLogging()  // optional, log user interactions automatically
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = AppNavigationController.sharedInstance
        window?.makeKeyAndVisible()
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Disable dark mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }
        
        return true
    }

    // MARK: - Init services
    private func initServices() {
        _ = _NavController
        _ = _AppCoreData
        _ = _UserServices
        _ = _CartServices
        _ = _CheckoutServices
        _ = _BookingServices
    }
}
