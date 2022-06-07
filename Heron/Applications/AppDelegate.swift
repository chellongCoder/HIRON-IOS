//
//  AppDelegate.swift
//  Heron
//
//  Created by Luu Luc on 21/11/2021.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import BugfenderSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let sharedInstance       = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ApplicationTracking.shareInstance.commonConfig()
        _AppCoreData.startContext()
        _AppDataHandler.checkConnectionRepeatedly()
        IQKeyboardManager.shared.enable = true
        
        //MARK: Tracking
        Bugfender.activateLogger("PobpLgnctGQTDDJAGhLAJsyDNS8okX5A")
        Bugfender.enableCrashReporting()
//        Bugfender.enableUIEventLogging()  // optional, log user interactions automatically
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = AppNavigationController.sharedInstance
        window?.makeKeyAndVisible()
        
        //Disable dark mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }


    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Heron")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

