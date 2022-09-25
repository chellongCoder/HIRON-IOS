//
//  MyApoitmentViewController.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit
import RxSwift

class MyBookingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let stackView       = UIStackView()
    let tableView               = UITableView(frame: .zero, style: .plain)
    let viewModel               = MyBookingViewModel()
    private let allBtn          = UIButton()
    private let confirmedBtn    = UIButton()
    private let completeBtn     = UIButton()
    private var separatorView   = UIView()
    
    private var selectedSegmentBtn      : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookings"
        self.viewModel.controller = self
                
        let addNewBookingBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "plus"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(addNewBooking))
        self.navigationItem.rightBarButtonItem = addNewBookingBtn
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 1
        stackView.backgroundColor = .white
        self.loadHeaderView(stackView: stackView)
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(46)
        }
        
        separatorView.backgroundColor = kPrimaryColor
        self.view.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalTo(selectedSegmentBtn!)
            make.height.equalTo(2)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(MyBookingTableViewCell.self, forCellReuseIdentifier: "MyAppoitmentTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        _NavController.setNavigationBarHidden(true, animated: false)
        self.segmentBtnTapped(sender: self.allBtn)
    }
    
    @objc private func addNewBooking() {
        let navBookingFlow = UINavigationController.init(rootViewController: SelectEHPViewController())
        navBookingFlow.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navBookingFlow, animated: true, completion: nil)
    }
    
    private func loadHeaderView(stackView: UIStackView) {
        allBtn.isSelected = true
        self.selectedSegmentBtn = allBtn
        allBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        allBtn.setTitle("All", for: .normal)
        allBtn.setTitleColor(kDefaultTextColor, for: .normal)
        allBtn.setTitleColor(kPrimaryColor, for: .selected)
        allBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        allBtn.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        stackView.addArrangedSubview(allBtn)
        
        confirmedBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        confirmedBtn.setTitle("Confirmed", for: .normal)
        confirmedBtn.setTitleColor(kDefaultTextColor, for: .normal)
        confirmedBtn.setTitleColor(kPrimaryColor, for: .selected)
        confirmedBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        confirmedBtn.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        stackView.addArrangedSubview(confirmedBtn)
        
        completeBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        completeBtn.setTitle("Complete", for: .normal)
        completeBtn.setTitleColor(kDefaultTextColor, for: .normal)
        completeBtn.setTitleColor(kPrimaryColor, for: .selected)
        completeBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        completeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        stackView.addArrangedSubview(completeBtn)
    }
    
    @objc private func segmentBtnTapped(sender: UIButton) {
        
        if selectedSegmentBtn == sender && sender != self.allBtn {
            return
        }
        
        selectedSegmentBtn?.isSelected = false
        sender.isSelected = true
        selectedSegmentBtn = sender
        
        separatorView.snp.remakeConstraints { (remake) in
            remake.bottom.centerX.width.equalTo(selectedSegmentBtn!)
            remake.height.equalTo(2)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        switch sender {
        case self.allBtn:
            self.viewModel.filter.accept(nil)
//            tableViewIsScrolling = true
        case self.confirmedBtn:
            self.viewModel.filter.accept("confirmed")
//            tableViewIsScrolling = true
        case self.completeBtn:
            self.viewModel.filter.accept("completed")
//            tableViewIsScrolling = true
        default:
            break
        }
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        viewModel.listBookings
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listBookings.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast 
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppoitmentTableViewCell") as! MyBookingTableViewCell
        let cellData = viewModel.listBookings.value[indexPath.row]
        cell.setDataSource(cellData)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = viewModel.listBookings.value[indexPath.row]
        let bookingDetailsVC = BookingDetailViewController()
        self.navigationController?.pushViewController(bookingDetailsVC, animated: true)
        
        bookingDetailsVC.viewModel.bookingData.accept(cellData)
    }
}