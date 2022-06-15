//
//  VC_LunchScreen.swift
//  Heron
//
//  Created by Luu Lucas on 9/18/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import SWRevealViewController

let kMenuWidth       = 312.0

class LaunchScreenViewController: UIViewController {
        
    private let loadingAnimation    = VW_LoadingAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        
        self.view.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        
        
//        _AuthenticationServices.login { isSuccess, errorMessgae in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let homeVC = MainViewController()
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _NavController.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Process data
    private func checkUserLoggedIn() {
        self.startLoadingAnimation()
    }
}
