//
//  MyOrderViewController.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrderViewController: BaseViewController,
                             UITableViewDelegate, UITableViewDataSource,
                             EmptyViewDelegate {
    
    private let topScrollView   = UIScrollView()
    private let stackView       = UIView()
    let tableView               = UITableView(frame: .zero, style: .grouped)
    let emptyView               = EmptyView()
    let viewModel               = MyOrderViewModel()
    private let allBtn          = UIButton()
    private let pendingBtn      = UIButton()
    private let confirmedBtn    = UIButton()
    private let processingBtn   = UIButton()
    private let completeBtn     = UIButton()
    private let canceledBtn     = UIButton()
    private var separatorView   = UIView()
    
    private var selectedSegmentBtn      : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
        self.title = "Orders"
        
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
        tableView.register(MyOrderCell.self, forCellReuseIdentifier: "MyOrderCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview()
        }
        
        emptyView.titleLabel.text = "You current don't have any orders"
        emptyView.messageLabel.text = "Please buy some items"
        emptyView.actionButon.setTitle("Browse products", for: .normal)
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
        
        processingBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        processingBtn.setTitle("   ON-DELIVERY   ", for: .normal)
        processingBtn.setTitleColor(kDefaultTextColor, for: .normal)
        processingBtn.setTitleColor(kPrimaryColor, for: .selected)
        processingBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        stackView.addSubview(processingBtn)
        processingBtn.snp.makeConstraints { (make) in
            make.left.equalTo(confirmedBtn.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(46)
            make.right.lessThanOrEqualToSuperview()
        }
        
        completeBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        completeBtn.setTitle("   RECEIVED   ", for: .normal)
        completeBtn.setTitleColor(kDefaultTextColor, for: .normal)
        completeBtn.setTitleColor(kPrimaryColor, for: .selected)
        completeBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        stackView.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(processingBtn.snp.right).offset(2)
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
        
        switch sender {
        case self.allBtn:
            self.viewModel.filter.accept(nil)
//            tableViewIsScrolling = true
        case self.pendingBtn:
            self.viewModel.filter.accept("pending")
        case self.confirmedBtn:
            self.viewModel.filter.accept("confirmed")
        case self.processingBtn:
            self.viewModel.filter.accept("processing")
        case self.completeBtn:
            self.viewModel.filter.accept("completed")
        case self.canceledBtn:
            self.viewModel.filter.accept("canceled")
        default:
            break
        }
        
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
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        viewModel.orders
            .observe(on: MainScheduler.instance)
            .subscribe { listOrder in
                
                if listOrder.element?.isEmpty ?? false {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                    self.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.filter
            .observe(on: MainScheduler.instance)
            .subscribe { filterStr in
                guard let filterS = filterStr.element else {
                    self.emptyView.titleLabel.text = "You current don't have any orders"
                    self.emptyView.messageLabel.text = "Please buy some items"
                    return
                }
                
                switch filterS {
                case "pending":
                    self.emptyView.titleLabel.text = "You currently don't have any pending order"
                case "confirmed":
                    self.emptyView.titleLabel.text = "You currently don't have any confirmed order"
                case "processing":
                    self.emptyView.titleLabel.text = "You currently don't have any processing order"
                case "completed":
                    self.emptyView.titleLabel.text = "You currently don't have any complete order"
                case "canceled":
                    self.emptyView.titleLabel.text = "You currently don't have any canceled order"
                default:
                    self.emptyView.titleLabel.text = "You current don't have any orders"
                    self.emptyView.messageLabel.text = "Please buy some items"
                    break
                }
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
        title.text = orderData.store?.name ?? ""
        title.textColor = kDefaultTextColor
        title.font = getFontSize(size: 16, weight: .bold)
        
        headerView.addSubview(title)
        title.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        let status = UILabel()
        status.text = String(format: " %@ ", orderData.getOrderStatusValue())
        status.textColor = kPrimaryColor
        status.font = getFontSize(size: 14, weight: .regular)
        status.layer.borderWidth = 1
        status.layer.borderColor = kPrimaryColor.cgColor
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
    
    // MARK: - EmptyViewDelegate
    func didSelectEmptyButton() {
        _NavController.presentCartPage()
    }
}
