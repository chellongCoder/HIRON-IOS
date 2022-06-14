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
                (tableView: UITableView, index: Int, element: OrderData) in
                let cell = MyOrderCell(style: .default, reuseIdentifier:"MyOrderCell")
                cell.productTitleLabel.text = element.items?[0].name
                cell.priceLabel.text = "$\(element.items?[0].regularPrice ?? 0)"
                cell.priceDiscount.text = "$\(element.items?[0].finalPrice ?? 0)"
                cell.packageImage.setImage(url: URL(string: element.items?[0].thumbnailUrl ?? "")!, placeholder: UIImage(named: "default-image")!)
//                cell.setDataSource(element)
//                cell.delegate = self
                return cell
            }
            .disposed(by: disposeBag)
        
//        tableView.rx
//            .modelSelected(OrderData.self)
//            .observe(on: MainScheduler.instance)
//            .subscribe { model in
//                guard let orderData = model.element else {return}
//                let viewDetailsController = DetailOrderViewController.init(orderData)
//                self.navigationController?.pushViewController(viewDetailsController, animated: true)
//                
////                self.dismissKeyboard()
//            }
//            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewDetailsController = DetailOrderViewController.init(self.vm.orders.value[0])
        self.navigationController?.pushViewController(viewDetailsController, animated: true)
        
    }
}
