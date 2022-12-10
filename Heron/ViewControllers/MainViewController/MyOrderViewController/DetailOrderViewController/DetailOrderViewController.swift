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
    let tableView       = UITableView(frame: .zero, style: .plain)
    let viewModel       = DetailOrderViewModel()
    
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
        tableView.register(OrderStatusTableViewCell.self, forCellReuseIdentifier: "ProductStatusTableViewCell")
        tableView.register(ShippingAndBillingInfoTableViewCell.self, forCellReuseIdentifier: "ShippingInfoTableViewCell")
        tableView.register(TrackingTableViewCell.self, forCellReuseIdentifier: "TrackingTableViewCell")
        tableView.register(PaymentTableViewCell.self, forCellReuseIdentifier: "PaymentTableViewCell")
        tableView.register(PackageTableViewCell.self, forCellReuseIdentifier: "PackageTableViewCell")
        tableView.register(TotalOrderTableViewCell.self, forCellReuseIdentifier: "TotalOrderTableViewCell")
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: "StoreTableViewCell")
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let orderData = self.viewModel.orderData.value
        
        if indexPath.row == 0 {
            // swiftlint:disable force_cast 
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductStatusTableViewCell", for: indexPath) as! OrderStatusTableViewCell
            cell.setDataSource(orderData)
            return cell
        } else if indexPath.row == 1 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingTableViewCell", for: indexPath) as! TrackingTableViewCell
            cell.setDataSource(viewModel.shippingData.value)
            return cell
        } else if indexPath.row == 2 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingInfoTableViewCell", for: indexPath) as! ShippingAndBillingInfoTableViewCell
            cell.setUserData(orderData?.userData)
            cell.setShippingData(viewModel.shippingData.value)
            return cell
        } else if indexPath.row == 3 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as! StoreTableViewCell
            cell.setStoreDataSource(orderData?.store)
            return cell
        } else if indexPath.row == 4 + (orderData?.items?.count ?? 0) {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalOrderTableViewCell", for: indexPath) as! TotalOrderTableViewCell
            if orderData?.items?.count == 1 {
                cell.title.text = String(format: "Total (1 product):  %@", getMoneyFormat(orderData?.customAmount))
            } else {
                cell.title.text = String(format: "Total (%ld products):  %@", (orderData?.items?.count ?? 0), getMoneyFormat(orderData?.customAmount))
            }
            
            return cell
        } else if indexPath.row == 5 + (orderData?.items?.count ?? 0) {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            
            if let cards = orderData?.orderPayment?.metadata?.card {
                cell.paymentCardLabel.text = String(format: "%@ | %@%@",
                                                   cards.getBrandName(), String(repeating: "X", count: 10),
                                                   cards.last4 ?? "")
            }
            
            return cell
        } else {
            // swiftlint:disable force_cast
            let orderItemCell = tableView.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for: indexPath) as! PackageTableViewCell
            if let cellData = orderData?.items?[indexPath.row - 4] {
                orderItemCell.setDataSource(cellData)
            }
            return orderItemCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 + (self.viewModel.orderData.value?.items?.count ?? 0)
    }
}
