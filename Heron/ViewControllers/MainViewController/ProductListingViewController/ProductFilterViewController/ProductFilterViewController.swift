//
//  ProductFilterViewController.swift
//  Heron
//
//  Created by Luu Luc on 10/05/2022.
//

import UIKit

class ProductFilterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
