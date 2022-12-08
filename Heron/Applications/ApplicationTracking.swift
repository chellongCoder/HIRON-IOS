//
//  ApplicationTracking.swift
//  Heron
//
//  Created by Triet Nguyen on 16/03/2021.
//  Copyright © 2021 Luu Lucas. All rights reserved.
//

// import Branch
import AppTrackingTransparency

enum ScreenName: String {
    case Home = "Home"
}

enum ScreenType: String {
    case Home = "home"
}

enum Event {
    case SUCCESS_PURCHASE
    case SUCCESS_VIEW_CART
    
    case SUCCESS_VIEW_ITEM
    case SUCCESS_CONTACT_SENT
    case SUCCESS_COMPLETEREGISTRATION
}

enum MixPannelEvent: String {
    case COMPLETE_REGISTRATION = "complete_registration"
    case SCREEN_VIEW = "screen_view"
    case PRESS_SERVICE_HOME = "press_service_home"
    case PRESS_SERVICE_BOTTOM = "press_service_bottom"
}

class ApplicationTracking: NSObject {
    public static let shareInstance     = ApplicationTracking()
    private var isAllowTrackingStatus   = true
    
    private var startTime: Date?
    
    var trackingAllow = false
    
    func commonConfig() {
        if #available(iOS 14.0, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                ATTrackingManager.requestTrackingAuthorization { status in
                    if status == .authorized {
                        self.initConfig()
                        self.trackingAllow = true
                    }
                }
            }
        } else {
            self.initConfig()
            self.trackingAllow = true
        }
    }
    
    private func initConfig() {
        // MARK: Config Tracking
        
        Bugfender.activateLogger("C8uxB1PX8YxAsqgZiDc9H1yjPuL7rP7i")
        Bugfender.enableCrashReporting()
        //        Bugfender.enableUIEventLogging() // optional, log user interactions automatically
        
        // Mixpanel.initialize(token: kMixPannelKey)
        
#if DEBUG
        // if you are using the TEST key
        // AppsFlyerLib.shared().isDebug = true
#else
        // AppsFlyerLib.shared().isDebug = false
        // Config firebase
        // FirebaseApp.configure()
#endif
    }
    
    func logEvent(_ type: Event, _ data: Any? = nil) {
        switch type {
        case .SUCCESS_COMPLETEREGISTRATION:
            // Analytics.logEvent("complete_registration", parameters: nil)
            // AppsFlyerLib.shared().logEvent("complete_registration", withValues: nil)
            
            self.logMixPannelEvent(.COMPLETE_REGISTRATION)
        case .SUCCESS_PURCHASE:
            // Analytics.logEvent("Purchase", parameters: data as? [String:Any])
            
            guard var tempData = data as? [String:Any] else { return }
            tempData["af_revenue"] = tempData["chi_phi"]
            tempData["af_currency"] = "VND"
            tempData["af_customer_user_id"] = _AppCoreData.userDataSource.value?.userPhoneNum
            // AppsFlyerLib.shared().logEvent("Purchase",
            // withValues: tempData)
        case .SUCCESS_VIEW_CART:
            // Analytics.logEvent("View_Cart", parameters: nil)
            // AppsFlyerLib.shared().logEvent("View_Cart", withValues: nil)
            break
            //        case .SUCCESS_ADD_TO_CART:
            //             Analytics.logEvent("Add_To_Cart", parameters: data as? [String:Any])
            //             AppsFlyerLib.shared().logEvent("Add_To_Cart", withValues: data as? [String:Any])
            //        case .SUCCESS_APPOINTMENT_SCHEDULING:
            //             Analytics.logEvent("Success_Appointment_Scheduling", parameters: data as? [String:Any])
            //
            //            guard var tempData = data as? [String:Any] else { return }
            //            tempData["af_revenue"] = tempData["chi_phi"]
            //            tempData["af_currency"] = "VND"
            //            tempData["af_customer_user_id"] = _AppCoreData.getUserDataSource()?.userPhoneNum
            //             AppsFlyerLib.shared().logEvent("Success_Appointment_Scheduling", withValues:tempData)
            //        case .SUCCESS_ONLINE_CONSULTATION:
            //             Analytics.logEvent("Success_Online_Consultation", parameters: data as? [String:Any])
            //
            //            guard var tempData = data as? [String:Any] else { return }
            //            tempData["af_revenue"] = tempData["chi_phi"]
            //            tempData["af_currency"] = "VND"
            //            tempData["af_customer_user_id"] = _AppCoreData.getUserDataSource()?.userPhoneNum
            //             AppsFlyerLib.shared().logEvent("Success_Online_Consultation", withValues: tempData)
            //            break
            //        case .SUCCESS_MEDICAL_DECLARATION_FORM:
            //             Analytics.logEvent("Medical_Declaration_Form", parameters: data as? [String:Any])
            //             AppsFlyerLib.shared().logEvent("Medical_Declaration_Form", withValues: data as? [String:Any])
            //            break
            //        case .APPOINTMENT_SCHEDULING:
            //             Analytics.logEvent("Appointment_Scheduling", parameters: data as? [String:Any])
            //             AppsFlyerLib.shared().logEvent("Appointment_Scheduling", withValues: data as? [String:Any])
            //            break
            //        case .ONLINE_CONSULATION:
            //             Analytics.logEvent("Online_Consulation", parameters: data as? [String:Any])
            //             AppsFlyerLib.shared().logEvent("Online_Consulation", withValues: data as? [String:Any])
            //            break
        default:
            break
        }
    }
    
    // Batch integration with AppsFlyer
    ////https://support.appsflyer.com/hc/en-us/articles/360000833437-Batch-integration-with-AppsFlyer
    
    func setCustomerId(_ phone: String) {
        // AppsFlyerLib.shared().customerUserID = phone
    }
}

// MARK: - send Bugfender Error log
extension ApplicationTracking {
    
    public func sendErrorLog(_ text: String) {
        _ = Bugfender.sendIssueReturningUrl(withTitle: "App Error", text: text)
    }
}

// MARK: MixPannel
extension ApplicationTracking {
    func logMixPannelEvent(_ type: MixPannelEvent, _ data: Any? = nil) {
        if data != nil {
            // Mixpanel.mainInstance().track(event: type.rawValue, properties: data as! [String:String])
        } else {
            // Mixpanel.mainInstance().track(event: type.rawValue, properties: nil)
        }
    }
    
    func screenShown() {
        self.startTime = Date()
    }
    
    func screenHidden(completion: @escaping (_ time: Int) -> Void) {
        guard let startTime = self.startTime else { return }
        let time = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
        
        completion(Int(time))
    }
}
