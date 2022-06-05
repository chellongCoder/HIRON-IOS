//
//  HomeViewController.swift
//  Heron
//
//  Created by Luu Luc on 26/04/2022.
//

import UIKit

class MainViewController: UITabBarController {

    public static let sharedInstance = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = kPrimaryColor
        self.tabBar.backgroundColor = .white
        self.setNavigationBarAppearance(color: .white)
        
     
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white // The background color.
            
            self.tabBar.standardAppearance = appearance
//              self.tabBar.scrollEdgeAppearance = view.standardAppearance

        }
        
        
        let homeNav = UINavigationController.init(rootViewController: HomepageViewController())
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage.init(systemName: "house"), selectedImage: nil)

        let productNav = UINavigationController.init(rootViewController: ProductListingViewController())
        productNav.tabBarItem = UITabBarItem(title: "Product", image: UIImage.init(systemName: "cart"), selectedImage: nil)

        let myOrderNav = UINavigationController.init(rootViewController: MyOrderViewController())
        myOrderNav.tabBarItem = UITabBarItem(title: "My Order", image: UIImage.init(systemName: "person"), selectedImage: nil)

        self.viewControllers = [homeNav, productNav, myOrderNav]
        self.selectedIndex = 1
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(true, animated: true)
        
        let is_signed = UserDefaults.standard.bool(forKey: "is_login")
        if !is_signed {
            let auth = UINavigationController(rootViewController: MainAuthViewController())
            auth.modalPresentationStyle = .fullScreen
            self.present(auth, animated: true, completion: nil)
        }
        
    }
}
