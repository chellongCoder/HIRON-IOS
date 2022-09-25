//
//  MyApoitmentViewController.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit
import RxSwift

class MyBookingsViewController: BaseViewController,
                                UITableViewDelegate, UITableViewDataSource,
                                EmptyViewDelegate {

    private let topScrollView   = UIScrollView()
    private let stackView       = UIView()
    let tableView               = UITableView(frame: .zero, style: .plain)
    let emptyView               = EmptyView()
    let viewModel               = MyBookingViewModel()
    private let allBtn          = UIButton()
    private let pendingBtn      = UIButton()
    private let confirmedBtn    = UIButton()
    private let completeBtn     = UIButton()
    private let canceledBtn     = UIButton()
    private var separatorView   = UIView()
    
    private var selectedSegmentBtn      : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
                
        let addNewBookingBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "plus"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(addNewBooking))
        self.navigationItem.rightBarButtonItem = addNewBookingBtn
        
        topScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(topScrollView)
        topScrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(46)
        }
        
        stackView.backgroundColor = .white
        self.topScrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.height.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-10)
        }
        
        self.loadHeaderView(stackView: stackView)
        
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
        
        emptyView.titleLabel.text = "Your booking list is empty"
        emptyView.messageLabel.text = "You can make complete new booking here"
        emptyView.actionButon.setTitle("Create new Booking", for: .normal)
        emptyView.delegate = self
        emptyView.isHidden = true
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.size.equalTo(tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentBtnTapped(sender: self.allBtn)
    }
    
    @objc private func addNewBooking() {
        let navBookingFlow = UINavigationController.init(rootViewController: SelectEHPViewController())
        navBookingFlow.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navBookingFlow, animated: true, completion: nil)
    }
    
    private func loadHeaderView(stackView: UIView) {
        allBtn.isSelected = true
        self.selectedSegmentBtn = allBtn
        allBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        allBtn.setTitle("   ALL   ", for: .normal)
        allBtn.setTitleColor(kDefaultTextColor, for: .normal)
        allBtn.setTitleColor(kPrimaryColor, for: .selected)
        allBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        stackView.addSubview(allBtn)
        allBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        
        pendingBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        pendingBtn.setTitle("   PENDING   ", for: .normal)
        pendingBtn.setTitleColor(kDefaultTextColor, for: .normal)
        pendingBtn.setTitleColor(kPrimaryColor, for: .selected)
        pendingBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        stackView.addSubview(pendingBtn)
        pendingBtn.snp.makeConstraints { (make) in
            make.left.equalTo(allBtn.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        
        confirmedBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        confirmedBtn.setTitle("   CONFIRMED   ", for: .normal)
        confirmedBtn.setTitleColor(kDefaultTextColor, for: .normal)
        confirmedBtn.setTitleColor(kPrimaryColor, for: .selected)
        confirmedBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        stackView.addSubview(confirmedBtn)
        confirmedBtn.snp.makeConstraints { (make) in
            make.left.equalTo(pendingBtn.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        
        completeBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        completeBtn.setTitle("   RECEIVED   ", for: .normal)
        completeBtn.setTitleColor(kDefaultTextColor, for: .normal)
        completeBtn.setTitleColor(kPrimaryColor, for: .selected)
        completeBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        stackView.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(confirmedBtn.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        
        canceledBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        canceledBtn.setTitle("   CANCELED   ", for: .normal)
        canceledBtn.setTitleColor(kDefaultTextColor, for: .normal)
        canceledBtn.setTitleColor(kPrimaryColor, for: .selected)
        canceledBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        stackView.addSubview(canceledBtn)
        canceledBtn.snp.makeConstraints { (make) in
            make.left.equalTo(completeBtn.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(46)
            make.right.lessThanOrEqualToSuperview()
        }
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
        case self.pendingBtn:
            self.viewModel.filter.accept("pending")
        case self.confirmedBtn:
            self.viewModel.filter.accept("confirmed")
        case self.completeBtn:
            self.viewModel.filter.accept("completed")
        case self.canceledBtn:
            self.viewModel.filter.accept("canceled")
        default:
            break
        }
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        viewModel.listBookings
            .observe(on: MainScheduler.instance)
            .subscribe { listBooking in
                
                if listBooking.element?.isEmpty ?? false {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                    self.tableView.reloadData()
                }
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
    
    // MARK: - EmptyViewDelegate
    func didSelectEmptyButton() {
        self.addNewBooking()
    }
}
