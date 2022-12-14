//
//  ViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit
import RxRelay
import RxSwift

class DetailOrderViewController: BaseViewController {
    
    let button1         = UIButton()
    let button2         = UIButton()
    
    let tableView       = UITableView(frame: .zero, style: .grouped)
    let viewModel       = DetailOrderViewModel()
    
    let statusView      = OrderStatusView()
    let trackingView    = OrderTrackingView()
    let shipingView     = ShippingAndBillingInfoView()
    let totalInView     = OrderTotalInView()
    let orderStoreView  = OrderStoreView()
    let paymentView     = PaymentView()
    
    init(_ data: OrderDataSource) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.orderData.accept(data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        self.title = "Order Details"
        
        self.showBackBtn()
        
        let supportBtn = UIBarButtonItem.init(image: UIImage.init(named: "customer_support_icon"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(customerSupportButtonTapped))
        self.navigationItem.rightBarButtonItem = supportBtn
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        button1.setTitle("Chat", for: .normal)
        button1.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        button1.setTitleColor(kPrimaryColor, for: .normal)
        button1.titleLabel?.textAlignment = .center
        button1.layer.cornerRadius = 20
        button1.layer.borderColor = kPrimaryColor.cgColor
        button1.layer.borderWidth = 0.7
        bottomView.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-30)
        }
        
        button2.setTitle("Track order", for: .normal)
        button2.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        button2.setTitleColor(kPrimaryColor, for: .normal)
        button2.titleLabel?.textAlignment = .center
        button2.layer.cornerRadius = 20
        button2.layer.borderColor = kPrimaryColor.cgColor
        button2.layer.borderWidth = 0.7
        bottomView.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.top.bottom.height.width.equalTo(button1)
            make.right.equalToSuperview().offset(-16)
        }
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(PackageTableViewCell.self, forCellReuseIdentifier: "PackageTableViewCell")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
//            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func customerSupportButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature is not available at the moment.",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                             style: .default,
                                             handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)    }
    
    override func bindingData() {
        self.viewModel.orderData
            .observe(on: MainScheduler.instance)
            .subscribe { orderData in
                
                if orderData.element == nil {return}
                self.viewModel.getOrderShippingInfo()
                self.tableView.reloadData()
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.shippingData
            .observe(on: MainScheduler.instance)
            .subscribe { shippingData in
                if shippingData.element == nil {return}
                self.tableView.reloadData()
            }
            .disposed(by: self.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.orderData.value?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let orderData = self.viewModel.orderData.value
        statusView.setDataSource(orderData)
        headerView.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        trackingView.setDataSource(orderData)
        headerView.addSubview(trackingView)
        trackingView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).offset(6)
            make.centerX.width.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        shipingView.setUserData(orderData?.userData)
        shipingView.setShippingData(viewModel.shippingData.value)
        headerView.addSubview(shipingView)
        shipingView.snp.makeConstraints { make in
            make.top.equalTo(trackingView.snp.bottom).offset(6)
            make.width.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        if orderData?.items?.count == 1 {
            totalInView.title.text = String(format: "Total (1 product):  %@", getMoneyFormat(orderData?.customAmount))
        } else {
            totalInView.title.text = String(format: "Total (%ld products):  %@", (orderData?.items?.count ?? 0), getMoneyFormat(orderData?.customAmount))
        }
        headerView.addSubview(totalInView)
        totalInView.snp.makeConstraints { make in
            make.top.equalTo(shipingView.snp.bottom).offset(6)
            make.width.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        orderStoreView.setStoreDataSource(orderData?.store)
        headerView.addSubview(orderStoreView)
        orderStoreView.snp.makeConstraints { make in
            make.top.equalTo(totalInView.snp.bottom).offset(6)
            make.width.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let orderData = self.viewModel.orderData.value
        
        // swiftlint:disable force_cast
        let orderItemCell = tableView.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for: indexPath) as! PackageTableViewCell
        if let cellData = orderData?.items?[indexPath.row] {
            orderItemCell.setDataSource(cellData)
        }
        return orderItemCell        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.paymentView
    }
}
