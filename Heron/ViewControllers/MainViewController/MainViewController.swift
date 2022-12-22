//
//  HomeViewController.swift
//  Heron
//
//  Created by Luu Luc on 26/04/2022.
//

import UIKit

class MainViewController: UITabBarController {

    public static let sharedInstance = MainViewController()
    
//    let customTabBar = AppTabBar()
//    override var tabBar: UITabBar {
//        return customTabBar
//    }
    
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
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowColor = kPrimaryColor.cgColor
        tabBar.layer.shadowOpacity = 0.6
        
        let myOrderNav = UINavigationController.init(rootViewController: MyOrderViewController())
        myOrderNav.tabBarItem = UITabBarItem(title: "My orders",
                                             image: UIImage.init(named: "order_tabbar_unselected"),
                                             selectedImage: UIImage.init(named: "order_tabbar_selected"))

        let productNav = UINavigationController.init(rootViewController: ProductListingViewController())
        productNav.tabBarItem = UITabBarItem(title: "Product",
                                             image: UIImage.init(named: "product_list_tabbar_unselected"),
                                             selectedImage: UIImage.init(named: "product_list_tabbar_selected"))
        
        let homeNav = UINavigationController.init(rootViewController: HomepageViewController())
        homeNav.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: ""), selectedImage: nil)
        
        let bookingNav = UINavigationController.init(rootViewController: MyBookingsViewController())
        bookingNav.tabBarItem = UITabBarItem(title: "Bookings",
                                             image: UIImage.init(named: "booking_tabbar_unselected"),
                                             selectedImage: UIImage.init(named: "booking_tabbar_selected"))

        let myProfileNav = UINavigationController.init(rootViewController: UserProfileViewController())
        myProfileNav.tabBarItem = UITabBarItem(title: "Profile",
                                               image: UIImage.init(named: "user_tabbar_unselected"),
                                               selectedImage: UIImage.init(named: "user_tabbar_selected"))
        
        self.viewControllers = [myOrderNav, productNav, homeNav, bookingNav, myProfileNav]
        self.selectedIndex = 2
        
        let customView = ExtendedButton()
        customView.backgroundColor = kPrimaryColor
        customView.setBackgroundImage(UIImage.init(named: "home_tabbar_icon"), for: .normal)
        customView.addTarget(self, action: #selector(didTapHomeButton), for: .touchUpInside)
        customView.layer.cornerRadius = 35
        customView.layer.borderColor = UIColor.white.cgColor
        customView.layer.borderWidth = 5
        self.tabBar.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.centerY.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func didTapHomeButton() {
        self.selectedIndex = 2
    }
}
