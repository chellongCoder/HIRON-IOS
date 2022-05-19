//
//  CartViewController.swift
//  Heron
//
//  Created by Luu Luc on 10/05/2022.
//

import UIKit

class CartViewController: BaseViewController,
                          UITableViewDataSource, UITableViewDelegate,
                          CartProductCellDelegate {
    
    public static let sharedInstance    = CartViewController()
    private let viewModel               = CartViewModel()
    let tableView                       = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Cart"
        self.viewModel.controller = self
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let checkoutBtn = UIBarButtonItem.init(title: "Checkout",
                                               style: .plain,
                                               target: self,
                                               action: #selector(checkoutButtonTapped))
        self.navigationItem.rightBarButtonItem = checkoutBtn

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kNeutralColor
        tableView.register(CartProductTableViewCell.self, forCellReuseIdentifier: "CartProductTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.center.size.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.reloadCart()
    }
    
    //MARK: - Buttons
    @objc private func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func checkoutButtonTapped() {
        
    }
    
    //MARK: - Cart
    func addProductToCart(_ data: ProductDataSource) {
        viewModel.addToCart(product: data)
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cartDataSource?.store.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartDataSource?.store[section].cartItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductTableViewCell") as! CartProductTableViewCell
        let storeData = viewModel.cartDataSource?.store[indexPath.section]
        if let cellData = storeData?.cartItems[indexPath.row].product {
            cell.setDataSource(cellData, indexPath: indexPath)
            if cellData.discountPercent > 0 {
                cell.discountPercent.text = String(format: "-%.f%%", cellData.discountPercent )
            } else {
                cell.discountPercent.isHidden = true
            }
        }
        
        cell.delegate = self
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        if let storeData = viewModel.cartDataSource?.store[section] {
            let titleSignal = UILabel()
            titleSignal.text = storeData.storeDetails?.name ?? ""
            headerView.addSubview(titleSignal)
            titleSignal.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.height.equalTo(30)
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - CartProductCellDelegate
    func removeItemFromCart(_ index: IndexPath) {
        guard let store = viewModel.cartDataSource?.store[index.section] else {return}
        let cartItem = store.cartItems[index.row]
        viewModel.removeItemFromCart(cartItem)
    }
}
