//
//  NavigationController.swift
//  Heron
//
//  Created by Luu Lucas on 9/18/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    public static let sharedInstance    = AppNavigationController(rootViewController: CartViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private weak var currentAlertVC : UIAlertController? = nil
    func showAlert(_ alert: UIAlertController) {
        if let currentAlert = self.currentAlertVC {
            currentAlert.dismiss(animated: true) {
                self.currentAlertVC = alert
                let vc = self as UIViewController
                vc.presentViewController(alert)
                
            }
        } else {
            self.currentAlertVC = alert
            let vc = self as UIViewController
            vc.presentViewController(alert)
        }
    }
    
    func doneAlert() {
        self.currentAlertVC = nil
    }
}

public let kCompletionActionDefault: (() -> Void) = {_NavController.doneAlert()}

//MARK: - Router
extension AppNavigationController {
    
    
}

//MARK: Force Update
extension AppNavigationController {
    
    func redirectToAppStore() {
        if let url = URL(string: kAppStoreReleaseURL),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
