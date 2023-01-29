//
//  WishListProductController.swift
//  Heron
//
//  Created by Longnn on 28/01/2023.
//

import Foundation
class WishListProductController: BaseViewController,
                                    UITableViewDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.showBackBtn()
        self.navigationItem.title = "Wishlist"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
