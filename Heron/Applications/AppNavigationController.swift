//
//  NavigationController.swift
//  Heron
//
//  Created by Luu Lucas on 9/18/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    public static let sharedInstance    = AppNavigationController(rootViewController: LunchScreenViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

//Deeplink Router
extension AppNavigationController {
    
}

//Notifications badge for AppNavigationController
extension AppNavigationController {
    func getUserNotificationCount() {
        _ = _AppDataHandler.getUserNotificationCount(completion: { (isSuccess, _, count) in
            if isSuccess {
                NotificationCenter.default.post(name: kNeedReloadNotificationBagde, object: nil)
            }
        })
    }
}

//MARK: Force Update
extension AppNavigationController {
    
    func redirectToAppStore() {
        if let url = URL(string: kAppStoreReleaseURL),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func checkVersion(completion: @escaping (()->Void)) {
        guard let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        _ = _AppDataHandler.getNewestVersion { (isSuccess, _, version) in
            if isSuccess {
                guard let iOSMinVersion = version else {
                    completion()
                    return
                }
                if ourVersion.compare(iOSMinVersion, options: .numeric) == .orderedAscending {
                    _NavController.showAlertWarning(NSLocalizedString("kAlertTitle", comment: ""),
                                                    NSLocalizedString("kForceUpdateMessage", comment: ""),
                                                    NSLocalizedString("kOkAction", comment: ""),
                                                    successCompletion: {
                                                        // handle download new version
                                                        self.redirectToAppStore()
                                                    })
                } else {
                    DispatchQueue.global().async {
                        _AppDataHandler.isUpdateAvailable { (isUpdate) in
                            DispatchQueue.main.async {
                                if isUpdate {
                                    _NavController.showAlertConfirmation(NSLocalizedString("kAlertTitle", comment: ""),
                                                                         NSLocalizedString("kForceUpdateMessage", comment: ""),
                                                                         NSLocalizedString("kOkAction", comment: ""),
                                                                         NSLocalizedString("kAfterAction", comment: ""),
                                                                         successCompletion: {
                                                                            // handle download new version
                                                                            self.redirectToAppStore()
                                                                            completion()
                                                                         }, failureCompletion: {
                                                                            completion()
                                                                         })
                                } else {
                                    completion()
                                }
                            }
                        }
                    }
                }
            } else {
                completion()
            }
        }
    }
}

extension AppNavigationController {
    
    func showAlertWarning(_ title: String,
                          _ message: String,
                          _ okTitle: String,
                          successCompletion: (()->Void)?) {

        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: okTitle, style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
                successCompletion?()
            }
            
            alert.addAction(okAction)
            alert.modalTransitionStyle = .crossDissolve
            alert.modalPresentationStyle = .overFullScreen

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertConfirmation(_ title: String,
                               _ message: String,
                               _ okTitle: String,
                               _ cancelTitle: String? = nil,
                               successCompletion: @escaping ()->Void,
                               failureCompletion: (()->Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: okTitle, style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
                successCompletion()
            }
            let cancelAction = UIAlertAction.init(title: cancelTitle, style: .cancel) { action in
                alert.dismiss(animated: true, completion: nil)
                failureCompletion?()
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            alert.modalTransitionStyle = .crossDissolve
            alert.modalPresentationStyle = .overFullScreen

            self.present(alert, animated: true, completion: nil)
        }
    }
}
