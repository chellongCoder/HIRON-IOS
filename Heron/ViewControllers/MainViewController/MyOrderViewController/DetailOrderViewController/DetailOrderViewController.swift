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
    let tableView       = UITableView(frame: .zero, style: .insetGrouped)
    let viewModel       = DetailOrderViewModel()
    
    let statusView      = OrderStatusView()
    let trackingView    = OrderTrackingView()
    let shipingView     = ShippingAndBillingInfoView()
    let totalInView     = OrderTotalInView()
    let orderStoreView  = OrderStoreView()
    let paymentView     = PaymentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        self.title = "Order Details"
        
        self.showBackBtn()
        
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
            make.bottom.equalToSuperview()
        }
    }
    
    init(_ data: OrderDataSource?) {
        
        #warning("ANh Luc hard code lafm UI")
        
        if let data = data {
            UserDefaults.standard.setValue(data.toJSONString(), forKey: "lucas test")
            super.init(nibName: nil, bundle: nil)
            self.viewModel.orderData.accept(data)
        } else {
            let cachedString = UserDefaults.standard.string(forKey: "lucas test") as? String ?? ""
            
            let cachedData = OrderDataSource.init(JSONString: cachedString)
            super.init(nibName: nil, bundle: nil)
            self.viewModel.orderData.accept(cachedData)
        }
    }
    
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
        
        trackingView.setDataSource(self.viewModel.shippingData.value)
        headerView.addSubview(trackingView)
        trackingView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        shipingView.setUserData(orderData?.userData)
        shipingView.setShippingData(viewModel.shippingData.value)
        headerView.addSubview(shipingView)
        shipingView.snp.makeConstraints { make in
            make.top.equalTo(trackingView.snp.bottom).offset(10)
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
            make.top.equalTo(shipingView.snp.bottom).offset(10)
            make.width.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        orderStoreView.setStoreDataSource(orderData?.store)
        headerView.addSubview(orderStoreView)
        orderStoreView.snp.makeConstraints { make in
            make.top.equalTo(totalInView.snp.bottom).offset(10)
            make.width.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
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
