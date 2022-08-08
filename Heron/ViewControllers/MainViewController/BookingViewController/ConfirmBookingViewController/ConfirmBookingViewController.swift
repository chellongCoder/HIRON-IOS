//
//  ConfirmBookingViewController.swift
//  Heron
//
//  Created by Luu Luc on 07/08/2022.
//

import UIKit

class ConfirmBookingViewController: BaseViewController,
                                    UITableViewDataSource, UITableViewDelegate {
    
    private let tableView   = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Booking Confirmation"
        
        self.showBackBtn()
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(BookingInfoTableViewCell.self, forCellReuseIdentifier: "BookingInfoTableViewCell")
        tableView.register(BookingDoctorTableViewCell.self, forCellReuseIdentifier: "BookingDoctorTableViewCell")
        tableView.register(BookingProfileTableViewCell.self, forCellReuseIdentifier: "BookingProfileTableViewCell")
        tableView.register(BookingPaymentTableViewCell.self, forCellReuseIdentifier: "BookingPaymentTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func backButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Confirm?", comment: ""),
                                             message: "Do you sure to cancel this booking?",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Keep editting", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
            self.navigationController?.popViewController(animated: true)
        }))
        _NavController.showAlert(alertVC)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = BookingInfoTableViewCell.init(style: .default, reuseIdentifier: "BookingInfoTableViewCell")
            return cell
        } else if indexPath.row == 1 {
            let cell = BookingDoctorTableViewCell.init(style: .default, reuseIdentifier: "BookingDoctorTableViewCell")
            return cell
        } else if indexPath.row == 2 {
            let cell = BookingProfileTableViewCell.init(style: .default, reuseIdentifier: "BookingProfileTableViewCell")
            return cell
        } else {
            let cell = BookingPaymentTableViewCell.init(style: .default, reuseIdentifier: "BookingPaymentTableViewCell")
            return cell
        }
    }
}
