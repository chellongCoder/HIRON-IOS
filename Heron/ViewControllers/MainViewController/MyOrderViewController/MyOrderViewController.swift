//
//  MyOrderViewController.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrderViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let stackView       = UIStackView()
    let tableView               = UITableView(frame: .zero, style: .grouped)
    let viewModel               = MyOrderViewModel()
    private let pendingBtn      = UIButton()
    private let confirmedBtn    = UIButton()
    private let completeBtn     = UIButton()
    private var separatorView   = UIView()
    
    private var selectedSegmentBtn      : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
        self.title = "Orders"
                
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
        tableView.register(MyOrderCell.self, forCellReuseIdentifier: "MyOrderCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.filter.accept("confirmed")
    }
    
    private func loadHeaderView(stackView: UIStackView) {
        pendingBtn.isSelected = true
        self.selectedSegmentBtn = pendingBtn
        pendingBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        pendingBtn.setTitle("Pending", for: .normal)
        pendingBtn.setTitleColor(kDefaultTextColor, for: .normal)
        pendingBtn.setTitleColor(kPrimaryColor, for: .selected)
        pendingBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        pendingBtn.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        stackView.addArrangedSubview(pendingBtn)
        
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
        
        if selectedSegmentBtn == sender {
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
        case self.pendingBtn:
            self.viewModel.filter.accept("pending")
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
        viewModel.orders
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyOrderCell(style: .default, reuseIdentifier:"MyOrderCell")
        if let element = viewModel.orders.value[indexPath.section].items?[indexPath.row] {
            cell.setDataSource(element, indexPath: indexPath)
        }
        
//        cell.productTitleLabel.text = element?.name
//        cell.priceLabel.text = "$\(element?.regularPrice ?? 0)"
//        cell.priceDiscount.text = "$\(element?.finalPrice ?? 0)"
//        if let url = URL(string: element?.thumbnailUrl ?? "") {
//            cell.packageImage.setImage(url: url, placeholder: UIImage(named: "default-image")!)
//        } else {
//            cell.packageImage.image = UIImage(named: "default-image")
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let orderData = self.viewModel.orders.value[section]
        
        let title = UILabel()
        title.text = "HARD_CODE"
        title.textColor = kDefaultTextColor
        title.font = getFontSize(size: 16, weight: .bold)
        
        headerView.addSubview(title)
        title.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        let status = UILabel()
        status.text = orderData.status ?? ""
        status.font = UIFont.systemFont(ofSize: 14)
        status.textColor = UIColor(red: 0.129, green: 0.6, blue: 0.839, alpha: 1)
        headerView.addSubview(status)
        status.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        let shippingStatus = UIButton()
        shippingStatus.setTitle("Receive order in \(TimeConverter().getDateFromInt(orderData.createdAt ?? 0))", for: .normal)
        shippingStatus.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shippingStatus.setTitleColor(.black, for: .normal)
        shippingStatus.contentHorizontalAlignment = .left
        headerView.addSubview(shippingStatus)
        shippingStatus.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let sessionData = self.viewModel.orders.value[section]
        
        let title = UILabel()
        title.text = String(format: "Total (%ld products): $%.2f",
                            sessionData.items?.count ?? 0,
                            sessionData.orderPayment?.metadata?.checkoutPriceData?.customTotalPayable ?? 0.0)
        title.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.right.equalToSuperview().offset(-15)
        }
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        headerView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orders.value[section].items?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.orders.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewDetailsController = DetailOrderViewController.init(self.viewModel.orders.value[indexPath.section])
        self.navigationController?.pushViewController(viewDetailsController, animated: true)
        
    }
}
