//
//  CheckoutViewController.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit

class CheckoutViewController: BaseViewController {
    
    private let viewModel   =  CheckoutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Check out"
    }
}
