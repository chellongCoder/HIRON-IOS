//
//  HomeViewController.swift
//  Heron
//
//  Created by Luu Luc on 26/04/2022.
//

import UIKit
import FluidTabBarController

class MainViewController: FluidTabBarController {

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
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 12
        tabBar.layer.shadowColor = kPrimaryColor.cgColor
        tabBar.layer.shadowOpacity = 0.6
        
        let myOrderNav = UINavigationController.init(rootViewController: MyOrderViewController())
        myOrderNav.tabBarItem = FluidTabBarItem(title: "Orders", image: UIImage.init(systemName: "bag"), selectedImage: nil)

        let productNav = UINavigationController.init(rootViewController: ProductListingViewController())
        productNav.tabBarItem = FluidTabBarItem(title: "Products", image: UIImage.init(systemName: "cart"), selectedImage: nil)
        
        let homeNav = UINavigationController.init(rootViewController: HomepageViewController())
        homeNav.tabBarItem = FluidTabBarItem(title: "Home", image: UIImage.init(systemName: "house"), selectedImage: nil)
        
        let bookingNav = UINavigationController.init(rootViewController: MyBookingsViewController())
        bookingNav.tabBarItem = FluidTabBarItem(title: "Bookings", image: UIImage.init(systemName: "calendar"), selectedImage: nil)

        let myProfileNav = UINavigationController.init(rootViewController: UserProfileViewController())
        myProfileNav.tabBarItem = FluidTabBarItem(title: "Profile", image: UIImage.init(systemName: "person"), selectedImage: nil)
        
        self.viewControllers = [myOrderNav, productNav, homeNav, bookingNav, myProfileNav]
        self.selectedIndex = 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(true, animated: true)
    }
}
