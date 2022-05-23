//
//  ApplicationMacros.swift
//  Heron
//
//  Created by Luu Lucas on 9/21/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import SnapKit
import SWRevealViewController
import SDWebImage

// MARK: Header
let _AppDelegate                    = AppDelegate.sharedInstance
let _NavController                  = AppNavigationController.sharedInstance
let _AppDataHandler                 = ApplicationDataHandler.sharedInstance
let _AppCoreData                    = ApplicationCoreData.sharedInstance

// Define key
let kUserSessionDataSource          = "kUserSessionDataSource"
let kUserProfileDataSource          = "kUserProfileDataSource"


// Base URL
let kGatewayAuthenticationURL               = "https://ehp-api.cbidigital.com/authentication-svc/api"
let kGatwayInventoryURL                     = "https://ehp-api.cbidigital.com/inventory-svc/api"
let kGatwayCartURL                          = "https://ehp-api.cbidigital.com/cart-svc/api"
let kGatewayOrderURL                        = "https://ehp-api.cbidigital.com/order-svc/api"
// Define notificationKey
let kUserLoggedInNotification               = Notification.Name("kUserLoggedInNotification")
let kUserSignOutNotification                = Notification.Name("kUserSignOutNotification")
let kInternetNotificationAlive              = Notification.Name("kInternetNotificationAlive")
let kNeedReloadNotificationBagde            = Notification.Name("kNeedReloadNotificationBagde")


// One Signal Key
let kOneSignalAppID                         = ""

// AppStore Release URL
let kAppStoreReleaseURL                     = "https://apps.apple.com/vn/app/danh-y/xxxxxx"
let kAppAlreadyLaunchedOnce                 = "AppAlreadyLaunchedOnce"
let kAppRefreshUserDataCacheTime            = "kAppRefreshUserDataCacheTime"
let kAppRefresTime                          = 7 * 24 * 3600
