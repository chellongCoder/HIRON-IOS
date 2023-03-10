//
//  ConfirmBookingViewController.swift
//  Heron
//
//  Created by Luu Luc on 07/08/2022.
//

import UIKit
import RxSwift

class ConfirmBookingViewController: BaseViewController,
                                    UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel   = ConfirmBookingViewModel()
    
    private let tableView   = UITableView()
    private let bookNowBtn  = UIButton()
    private let priceLabel  = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Booking Confirmation"
        viewModel.controller = self
        
        self.showBackBtn()
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        bookNowBtn.setTitle("Book Now", for: .normal)
        bookNowBtn.backgroundColor = kPrimaryColor
        bookNowBtn.layer.cornerRadius = 8
        bookNowBtn.addTarget(self, action: #selector(bookNowButtonTapped), for: .touchUpInside)
        bottomView.addSubview(bookNowBtn)
        bookNowBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(50)
            make.width.equalTo(110)
        }
        
        priceLabel.text = "Total: $0.00/ section"
        priceLabel.textColor = kDefaultTextColor
        priceLabel.font = getCustomFont(size: 16, name: .medium)
        bottomView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(50)
            make.right.equalTo(bookNowBtn.snp.left).offset(-5)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(BookingInfoTableViewCell.self, forCellReuseIdentifier: "BookingInfoTableViewCell")
        tableView.register(BookingDoctorTableViewCell.self, forCellReuseIdentifier: "BookingDoctorTableViewCell")
        tableView.register(BookingProfileTableViewCell.self, forCellReuseIdentifier: "BookingProfileTableViewCell")
        tableView.register(BookingPaymentTableViewCell.self, forCellReuseIdentifier: "BookingPaymentTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProductList()
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
    
    @objc private func bookNowButtonTapped() {
        viewModel.booking()
    }
    
    // MARK: - Data
    override func bindingData() {
        _BookingServices.bookingProduct
            .observe(on: MainScheduler.instance)
            .subscribe { bookingData in
                guard let bookingData = bookingData.element as? ProductDataSource else {return}
                self.priceLabel.text = String(format: "Total: %@ /section", getMoneyFormat(bookingData.customFinalPrice))
            }
            .disposed(by: disposeBag)
        
        _BookingServices.storeDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
