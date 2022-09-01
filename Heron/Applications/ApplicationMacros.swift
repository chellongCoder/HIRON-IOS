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

// MARK: - Services
let _AuthenticationServices         = AuthenticationServices.sharedInstance
let _UserServices                   = UserServices.sharedInstance
let _InventoryServices              = InventoryServices.sharedInstance
let _CartServices                   = CartServices.sharedInstance
let _DeliveryServices               = DeliveryServices.sharedInstance
let _PromotionServices              = PromotionServices.sharedInstance
let _CheckoutServices               = CheckoutServices.sharedInstance
let _OrderServices                  = OrderService.sharedInstance
let _SubscriptionService            = SubscriptionService.sharedInstance
let _BookingServices                = BookingServices.sharedInstance
let _PaymentServices                = PaymentServices.sharedInstance
let _EHProfileServices              = EHProfileServices.sharedInstance

// Define key
let kUserSessionDataSource          = "kUserSessionDataSource"
let kUserProfileDataSource          = "kUserProfileDataSource"

// Base URL
let kGatewayAuthenticationURL               = "https://ehp-api.cbidigital.com/authentication-svc/api"
let kGatewayUserServicesURL                 = "https://ehp-api.cbidigital.com/user-svc/api"
let kGatwayInventoryURL                     = "https://ehp-api.cbidigital.com/inventory-svc/api"
let kGatwayCartURL                          = "https://ehp-api.cbidigital.com/cart-svc/api"
let kGatewayOrderURL                        = "https://ehp-api.cbidigital.com/order-svc/api"
let kGatewayDeliveryServicesURL             = "https://ehp-api.cbidigital.com/delivery-svc/api"
let kGatwayPromotionURL                     = "https://ehp-api.cbidigital.com/promotion-svc/api"
let kGatewayPaymentURL                      = "https://ehp-api.cbidigital.com/payment-svc/api"
let kGatewayEHealthProfileURL               = "https://ehp-api.cbidigital.com/eprofile-svc/api"
let kGatewayOganizationURL                  = "https://ehp-api.cbidigital.com/organization-svc/api"
let kGatewayBookingURL                      = "https://ehp-api.cbidigital.com/booking-svc/api"

// Define notificationKey
let kInternetNotificationAlive              = Notification.Name("kInternetNotificationAlive")
let kNeedReloadNotificationBagde            = Notification.Name("kNeedReloadNotificationBagde")

// One Signal Key
let kOneSignalAppID                         = ""
let kStripePublishableKey                   = "pk_test_51Jex8JIub2RNmWLMzutVV6fT10rlNXOnjk1YxfjaPKsO1KciL5Fl26YvcK3X17rkgN2bwaB7BzP0f78tIjG3RhVV00yYDfcNnh"

// AppStore Release URL
let kAppStoreReleaseURL                     = "https://apps.apple.com/vn/app/danh-y/xxxxxx"
let kAppAlreadyLaunchedOnce                 = "AppAlreadyLaunchedOnce"
let kAppRefresTime                          = 7 * 24 * 3600
