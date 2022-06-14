//
//  MyOrderViewController.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrderViewController: BaseViewController, UITableViewDelegate, ProductCellDelegate {
    func addProductToCart(_ data: ProductDataSource) {
        
    }
    
    let tableView                   = UITableView(frame: .zero, style: .grouped)
    private let disposeBag          = DisposeBag()
    let vm = OrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Order"
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
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
            .subscribe { cartDataSource in
//                self.cartHotInfo.cartPriceValue.text = String(format: "$%ld", cartDataSource?.grandTotal ?? 0)
            }
            .disposed(by: disposeBag)
        
        vm.orders
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: ProductDataSource) in
                let cell = MyOrderCell(style: .default, reuseIdentifier:"MyOrderCell")
//                cell.setDataSource(element)
//                cell.delegate = self
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(ProductDataSource.self)
            .subscribe { model in
                guard let productData = model.element else {return}
                let viewDetailsController = DetailOrderViewController.init(productData)
                self.navigationController?.pushViewController(viewDetailsController, animated: true)
                
//                self.dismissKeyboard()
            }
            .disposed(by: disposeBag)
    }
}
