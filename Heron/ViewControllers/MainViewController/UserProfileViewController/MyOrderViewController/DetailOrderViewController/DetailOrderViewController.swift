//
//  ViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit
import RxRelay

class DetailOrderViewController: BaseViewController {
    let tableView       = UITableView(frame: .zero, style: .plain)
    let viewModel       = DetailOrderViewModel()
    let data            = BehaviorRelay<OrderDataSource?>(value: nil)
    
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
        tableView.register(ProductStatusTableViewCell.self, forCellReuseIdentifier: "ProductStatusTableViewCell")
        tableView.register(ShippingInfoTableViewCell.self, forCellReuseIdentifier: "ShippingInfoTableViewCell")
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
        self.data.accept(data)
        //        viewModel.productDataSource = data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMyOrder()
    }
    
    override func bindingData() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // swiftlint:disable force_cast 
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductStatusTableViewCell", for: indexPath) as! ProductStatusTableViewCell
            cell.descStatusLabel.text = "You will receive the order in \(TimeConverter().getDateFromInt(self.data.value?.createdAt ?? 0)). Please keep your phone to get calling from deliver"
            cell.orderDetailLabel.text = self.data.value?.orderPaymentId?.shortenID() ?? ""
            cell.purchasedLabel.text = TimeConverter().getDateFromInt(self.data.value?.orderPayment?.completedAt ?? 0)
            return cell
        } else if indexPath.row == 1 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingTableViewCell", for: indexPath) as! TrackingTableViewCell
            return cell
        } else if indexPath.row == 2 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingInfoTableViewCell", for: indexPath) as! ShippingInfoTableViewCell
            cell.orderIdLabel.text = "\(self.data.value?.metadata?.lastName ?? "") | \(self.data.value?.metadata?.phone ?? "Empty phonenumber")"
            cell.billingAddressName.text = "\(self.data.value?.metadata?.lastName ?? "") | \(self.data.value?.metadata?.phone ?? "Empty phonenumber")"
            cell.billingAddressEmail.text = self.data.value?.metadata?.email ?? ""
            return cell
        } else if indexPath.row == 3 + (self.data.value?.items?.count ?? 0) {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalOrderTableViewCell", for: indexPath) as! TotalOrderTableViewCell
            cell.title.text = String(format: "Total (%ld products):  $%.2f", (self.data.value?.items?.count ?? 0), self.data.value?.customAmount ?? 0.0)
            return cell
        } else if indexPath.row == 4 + (self.data.value?.items?.count ?? 0) {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            cell.descStatusLabel.text = String(format: "%@ | %@%@",
                                               self.data.value?.orderPayment?.metadata?.card?.brand ?? "Empty brand",
                                               String(repeating: "X", count: 10),
                                               self.data.value?.orderPayment?.metadata?.card?.last4 ?? "")
            return cell
        } else {
            // swiftlint:disable force_cast
            let orderItemCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
            if let cellData = self.data.value?.items?[indexPath.row - 3] {
                orderItemCell.setDataSource(cellData, indexPath: indexPath)
            }
            return orderItemCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5 + (self.data.value?.items?.count ?? 0)
    }
}
