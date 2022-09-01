//
//  UINavigationController_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit
import SWRevealViewController

extension UIViewController {
    var isModalPresenting: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }

    func startLoadingAnimation() {
        
        // remove old animations
        for sub in self.view.subviews where sub is LoadingAnimationView {
            sub.removeFromSuperview()
        }
        
        DispatchQueue.main.async {
            let loadingAnimation      = LoadingAnimationView()
            loadingAnimation.isHidden = false
            self.view.addSubview(loadingAnimation)
            loadingAnimation.snp.makeConstraints { (make) in
                make.center.size.equalToSuperview()
            }
        }
    }

    func getStartLoadingAnimation() -> UIView {
        let loadingAnimation      = LoadingAnimationView()
        loadingAnimation.isHidden = false
        self.view.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }

        return loadingAnimation
    }

    func endLoadingAnimation() {
        DispatchQueue.main.async {
            for view in self.view.subviews {
                if view .isKind(of: LoadingAnimationView.self) {
                    UIView.animate(withDuration: 1.0) {
                        view.alpha = 0.0
                    } completion: { (_) in
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }

    func startLoadingAnimationTimer(duration: Double) {
        let loadingAnimation      = LoadingAnimationView()
        loadingAnimation.isHidden = false
        self.view.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }

        UIView.animate(withDuration: duration, animations: {
            loadingAnimation.alpha = 0.0
        }, completion: { (_: Bool) in
            loadingAnimation.removeFromSuperview()
        })
    }
    
    func setNavigationBarAppearance(color: UIColor) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = color // The background color.
            
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
                      
        } else { // Background color support for older versions
            self.navigationController?.navigationBar.barTintColor = color
            
        }
    }
    
    func presentViewController(_ vc : UIViewController) {
        if self.presentedViewController is UIAlertController {
            if let vc = self.presentedViewController as? UIAlertController {
                vc.dismiss()
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if let presentedVC = self.presentedViewController {
            presentedVC.presentViewController(vc)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
}
