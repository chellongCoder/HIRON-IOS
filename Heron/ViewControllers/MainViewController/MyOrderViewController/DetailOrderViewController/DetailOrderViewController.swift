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
        self.title = "Detailed order"
        
        self.showBackBtn()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(OrderStatusTableViewCell.self, forCellReuseIdentifier: "ProductStatusTableViewCell")
        tableView.register(ShippingAndBillingInfoTableViewCell.self, forCellReuseIdentifier: "ShippingInfoTableViewCell")
        tableView.register(TrackingTableViewCell.self, forCellReuseIdentifier: "TrackingTableViewCell")
        tableView.register(PaymentTableViewCell.self, forCellReuseIdentifier: "PaymentTableViewCell")
        tableView.register(MyOrderCell.self, forCellReuseIdentifier: "MyOrderCell")
        tableView.register(TotalOrderTableViewCell.self, forCellReuseIdentifier: "TotalOrderTableViewCell")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    init(_ data: OrderDataSource) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.orderData.accept(data)
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
        } else if indexPath.row == 3 + (orderData?.items?.count ?? 0) {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalOrderTableViewCell", for: indexPath) as! TotalOrderTableViewCell
            cell.title.text = String(format: "Total (%ld products):  $%.2f", (orderData?.items?.count ?? 0), orderData?.customAmount ?? 0.0)
            return cell
        } else if indexPath.row == 4 + (orderData?.items?.count ?? 0) {
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
            let orderItemCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
            if let cellData = orderData?.items?[indexPath.row - 3] {
                orderItemCell.setDataSource(cellData, indexPath: indexPath)
            }
            return orderItemCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5 + (self.viewModel.orderData.value?.items?.count ?? 0)
    }
}
