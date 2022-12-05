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
        allBtn.titleLabel?.font = getCustomFont(size: 12, name: .semiBold)
        stackView.addSubview(allBtn)
        allBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        
//        pendingBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
//        pendingBtn.setTitle("   PENDING   ", for: .normal)
//        pendingBtn.setTitleColor(kDefaultTextColor, for: .normal)
//        pendingBtn.setTitleColor(kPrimaryColor, for: .selected)
//        pendingBtn.titleLabel?.font = getCustomFont(size: 12, weight: .semibold)
//        stackView.addSubview(pendingBtn)
//        pendingBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(allBtn.snp.right).offset(2)
//            make.top.bottom.equalToSuperview()
//            make.height.equalTo(46)
//        }
        
        confirmedBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        confirmedBtn.setTitle("   CONFIRMED   ", for: .normal)
        confirmedBtn.setTitleColor(kDefaultTextColor, for: .normal)
        confirmedBtn.setTitleColor(kPrimaryColor, for: .selected)
        confirmedBtn.titleLabel?.font = getCustomFont(size: 12, name: .semiBold)
        stackView.addSubview(confirmedBtn)
        confirmedBtn.snp.makeConstraints { (make) in
            make.left.equalTo(allBtn.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        
        processingBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        processingBtn.setTitle("   ON-DELIVERY   ", for: .normal)
        processingBtn.setTitleColor(kDefaultTextColor, for: .normal)
        processingBtn.setTitleColor(kPrimaryColor, for: .selected)
        processingBtn.titleLabel?.font = getCustomFont(size: 12, name: .semiBold)
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
        completeBtn.titleLabel?.font = getCustomFont(size: 12, name: .semiBold)
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
        canceledBtn.titleLabel?.font = getCustomFont(size: 12, name: .semiBold)
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
        
        let status = UILabel()
        status.text = String(format: " %@ ", orderData.getOrderStatusValue())
        status.textColor = kDefaultTextColor
        status.font = getCustomFont(size: 14, name: .bold)
        headerView.addSubview(status)
        status.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-16)
        }
        
        let liveIcon = UIView()
        liveIcon.backgroundColor = kPrimaryColor
        liveIcon.layer.cornerRadius = 3
        headerView.addSubview(liveIcon)
        liveIcon.snp.makeConstraints { make in
            make.centerY.equalTo(status)
            make.right.equalTo(status.snp.left).offset(-4)
            make.height.width.equalTo(6)
        }
        
        let idLabel = UILabel()
        idLabel.text = "ID order #\(orderData.code)"
        idLabel.font = getCustomFont(size: 13, name: .regular)
        idLabel.textColor = kDefaultTextColor
        headerView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(status.snp.bottom).offset(8)
            make.left.equalTo(status)
        }
        
        let date = UILabel()
        date.text = "Created Date \(TimeConverter().getDateFromInt(orderData.createdAt ?? 0))"
        date.font = getCustomFont(size: 11, name: .regular)
        date.textColor = kDefaultTextColor
        headerView.addSubview(date)
        date.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let sessionData = self.viewModel.orders.value[section]
        
        
        let totalLabel = UILabel()
        totalLabel.text = String(format: "Total %@", getMoneyFormat(sessionData.orderPayment?.metadata?.checkoutPriceData?.customTotalPayable))
        totalLabel.font = getCustomFont(size: 13, name: .regular)
        totalLabel.textColor = kDefaultTextColor
        headerView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-17)
        }
                
        let productCountLabel = UILabel()
        if sessionData.items?.count == 1 {
            productCountLabel.text = "1 product"
        } else {
            productCountLabel.text = String(format: "%ld products",
                                sessionData.items?.count ?? 0)
        }
        productCountLabel.font = getCustomFont(size: 11, name: .regular)
        productCountLabel.textColor = kDefaultTextColor
        headerView.addSubview(productCountLabel)
        productCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalLabel)
            $0.right.equalTo(totalLabel.snp.left).offset(-12)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        #warning("hardcode")
        
        let button1 = UIButton()
        button1.setTitle("   Button1   ", for: .normal)
        button1.setTitleColor( .white, for: .normal)
        button1.titleLabel?.font = getCustomFont(size: 13, name: .regular)
        button1.layer.cornerRadius = 15
        button1.layer.backgroundColor = kPrimaryColor.cgColor
        headerView.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(30)
        }
        
        let button2 = UIButton()
        button2.setTitle("   Button2   ", for: .normal)
        button2.titleLabel?.font = getCustomFont(size: 13, name: .regular)
        button2.setTitleColor(kPrimaryColor, for: .normal)
        button2.layer.borderColor = kPrimaryColor.cgColor
        button2.layer.borderWidth = 0.8
        button2.layer.cornerRadius = 15
        headerView.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.centerY.height.equalTo(button1)
            make.left.equalTo(button1.snp.right).offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        let separator = UIView()
        separator.backgroundColor = kLightGrayColor
        headerView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(0.5)
            make.width.equalToSuperview().offset(-32)
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
