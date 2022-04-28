//
//  ProductListingViewController.swift
//  Heron
//
//  Created by Luu Luc on 27/04/2022.
//

import UIKit

class ProductListingViewController: BaseViewController {
    private let viewModel       = ProductListingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        
    }
}
