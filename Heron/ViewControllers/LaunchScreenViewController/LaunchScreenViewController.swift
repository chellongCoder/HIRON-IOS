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

class LaunchScreenViewController: BaseViewController {
        
    private let loadingAnimation    = LoadingAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        let isSigned = UserDefaults.standard.bool(forKey: "is_login")
        if !isSigned {
            self.navigationController?.setViewControllers([MainAuthViewController()], animated: true)
        } else {
            _NavController.gotoHomepage()
            _UserServices.getUserProfile()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _NavController.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Process data
    private func checkUserLoggedIn() {
        self.startLoadingAnimation()
    }
}
