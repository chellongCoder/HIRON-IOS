//
//  BookingViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

class BookingViewController: BaseViewController {
    
    private let viewModel = BookingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "Booking"
        
        viewModel.controller = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getUserEHealthProfiles()
    }
    
    func didSelectedUserProfileButtonTapped() {
        let selectDepartmentVC = SelectDepartmentViewController()
        self.navigationController?.pushViewController(selectDepartmentVC, animated: true)
    }
}
