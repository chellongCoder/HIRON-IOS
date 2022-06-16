//
//  MyOrderViewController.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrderViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ProductCellDelegate {
    func addProductToCart(_ data: ProductDataSource) {
        
    }
    
    let tableView                   = UITableView(frame: .zero, style: .grouped)
    let vm = OrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Order"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(MyOrderCell.self, forCellReuseIdentifier: "MyOrderCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.getMyOrder()
    }
    
    //MARK: - Binding Data
    override func bindingData() {
        vm.orders
            .observe(on: MainScheduler.instance)
            .subscribe { data in
//                self.cartHotInfo.cartPriceValue.text = String(format: "$%ld", cartDataSource?.grandTotal ?? 0)
                
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
//        vm.orders
//            .bind(to: tableView.rx.items) {
//                (tableView: UITableView, index: Int, element: OrderData) in
//                let cell = MyOrderCell(style: .default, reuseIdentifier:"MyOrderCell")
//                cell.productTitleLabel.text = element.items?[0].name
//                cell.priceLabel.text = "$\(element.items?[0].regularPrice ?? 0)"
//                cell.priceDiscount.text = "$\(element.items?[0].finalPrice ?? 0)"
//                cell.packageImage.setImage(url: URL(string: element.items?[0].thumbnailUrl ?? "")!, placeholder: UIImage(named: "default-image")!)
//                return cell
//            }
//            .disposed(by: disposeBag)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyOrderCell(style: .default, reuseIdentifier:"MyOrderCell")
        let element = vm.orders.value[indexPath.section].items?[indexPath.row]
        cell.productTitleLabel.text = element?.name
       cell.priceLabel.text = "$\(element?.regularPrice ?? 0)"
       cell.priceDiscount.text = "$\(element?.finalPrice ?? 0)"
       cell.packageImage.setImage(url: URL(string: element?.thumbnailUrl ?? "")!, placeholder: UIImage(named: "default-image")!)
       return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let title = UILabel()
        title.text = "CBI healthcare center"
        title.font = UIFont.boldSystemFont(ofSize: 16)
        
        headerView.addSubview(title)
        title.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        let status = UILabel()
        status.text = "Preparing product"
        status.font = UIFont.systemFont(ofSize: 14)
        status.textColor = UIColor(red: 0.129, green: 0.6, blue: 0.839, alpha: 1)
        headerView.addSubview(status)
        status.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        let shippingStatus = UIButton()
        shippingStatus.setTitle("Receive order  in Feb 05, 2021 ", for: .normal)
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
        
        let title = UILabel()
        title.text = "Total (3 products):    $3.00"
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
        vm.orders.value[section].items?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        vm.orders.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewDetailsController = DetailOrderViewController.init(self.vm.orders.value[0])
        self.navigationController?.pushViewController(viewDetailsController, animated: true)
        
    }
}
