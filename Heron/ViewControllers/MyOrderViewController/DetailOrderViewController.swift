//
//  ViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import UIKit

class DetailOrderViewController: BaseViewController {
    let tableView                   = UITableView(frame: .zero, style: .grouped)
    let vm = OrderViewModel()
    
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
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    init(_ data: OrderData) {
        super.init(nibName: nil, bundle: nil)
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
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingTableViewCell", for: indexPath) as! TrackingTableViewCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingInfoTableViewCell", for: indexPath) as! ShippingInfoTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
}
