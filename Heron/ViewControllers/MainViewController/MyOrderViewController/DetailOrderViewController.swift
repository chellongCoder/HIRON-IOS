//
//  ViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit
import RxRelay

class DetailOrderViewController: BaseViewController {
    let tableView                   = UITableView(frame: .zero, style: .grouped)
    let vm = OrderViewModel()
    let data = BehaviorRelay<OrderData?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detailed order"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(ProductStatusTableViewCell.self, forCellReuseIdentifier: "ProductStatusTableViewCell")
        tableView.register(ShippingInfoTableViewCell.self, forCellReuseIdentifier: "ShippingInfoTableViewCell")
        tableView.register(TrackingTableViewCell.self, forCellReuseIdentifier: "TrackingTableViewCell")
        tableView.register(PaymentTableViewCell.self, forCellReuseIdentifier: "PaymentTableViewCell")
        tableView.register(MyOrderCell.self, forCellReuseIdentifier: "MyOrderCell")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    init(_ data: OrderData) {
        super.init(nibName: nil, bundle: nil)
        self.data.accept(data)
//        viewModel.productDataSource = data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.getMyOrder()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductStatusTableViewCell", for: indexPath) as! ProductStatusTableViewCell
            cell.descStatusLabel.text = "You will receive the order in \(TimeConverter().getDateFromInt(self.data.value?.createdAt ?? 0)). Please keep your phone to get calling from deliver"
            cell.orderDetailLabel.text = self.data.value?.orderPaymentId?.shortenID() ?? ""
            cell.purchasedLabel.text = TimeConverter().getDateFromInt(self.data.value?.orderPayment?.completedAt ?? 0)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingTableViewCell", for: indexPath) as! TrackingTableViewCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingInfoTableViewCell", for: indexPath) as! ShippingInfoTableViewCell
            cell.orderIdLabel.text = "\(self.data.value?.metadata?.lastName ?? "") | \(self.data.value?.metadata?.phone ?? "Empty phonenumber")"
            cell.billingAddressName.text = "\(self.data.value?.metadata?.lastName ?? "") | \(self.data.value?.metadata?.phone ?? "Empty phonenumber")"
            cell.billingAddressEmail.text = self.data.value?.metadata?.email ?? ""
            return cell
        } else if indexPath.row == 3 + (self.data.value?.items?.count ?? 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            cell.descStatusLabel.text = "\(self.data.value?.orderPayment?.metadata?.card?.brand ?? "Empty brand") | \(String(repeating: "X", count: 10))\(self.data.value?.orderPayment?.metadata?.card?.last4 ?? "")"
            return cell
        }
        
        let item_cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        return item_cell
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4 + (self.data.value?.items?.count ?? 0)
    }
}
