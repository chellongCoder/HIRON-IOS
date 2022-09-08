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
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white // The background color.
            
            self.tabBar.standardAppearance = appearance
//              self.tabBar.scrollEdgeAppearance = view.standardAppearance
        }
        
        let myOrderNav = UINavigationController.init(rootViewController: MyOrderViewController())
        myOrderNav.tabBarItem = UITabBarItem(title: "Orders", image: UIImage.init(systemName: "house"), selectedImage: nil)

        let productNav = UINavigationController.init(rootViewController: ProductListingViewController())
        productNav.tabBarItem = UITabBarItem(title: "Products", image: UIImage.init(systemName: "cart"), selectedImage: nil)
        
        let homeNav = UINavigationController.init(rootViewController: HomepageViewController())
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage.init(systemName: "house"), selectedImage: nil)
        
        let bookingNav = UINavigationController.init(rootViewController: MyBookingsViewController())
        bookingNav.tabBarItem = UITabBarItem(title: "Bookings", image: UIImage.init(systemName: "ticket"), selectedImage: nil)

        let myProfileNav = UINavigationController.init(rootViewController: UserProfileViewController())
        myProfileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage.init(systemName: "person"), selectedImage: nil)
        
        UINavigationBar.appearance().isTranslucent = false

        self.viewControllers = [myOrderNav, productNav, homeNav, bookingNav, myProfileNav]
        self.selectedIndex = 1
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(true, animated: true)
    }
}
