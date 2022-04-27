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
        DispatchQueue.main.async {
            let loadingAnimation      = VW_LoadingAnimation()
            loadingAnimation.isHidden = false
            self.view.addSubview(loadingAnimation)
            loadingAnimation.snp.makeConstraints { (make) in
                make.center.size.equalToSuperview()
            }
        }
    }

    func getStartLoadingAnimation() -> UIView {
        let loadingAnimation      = VW_LoadingAnimation()
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
                if view .isKind(of: VW_LoadingAnimation.self) {
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
        let loadingAnimation      = VW_LoadingAnimation()
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

}
