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
            make.top.centerX.width.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Buttons
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func checkoutButtonTapped() {
        
    }
    
    //MARK: - Cart
    func addProductToCart(_ data: ProductDataSource) {
        viewModel.listProducts.append(data)
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductTableViewCell") as! CartProductTableViewCell
        let cellData = viewModel.listProducts[indexPath.row]
        cell.setDataSource(cellData)
        cell.delegate = self
        if cellData.discountPercent > 0 {
            cell.discountPercent.text = String(format: "-%.f%%", cellData.discountPercent )
        } else {
            cell.discountPercent.isHidden = true
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    //MARK: - CartProductCellDelegate
    func removeProductFromCart(_ data: ProductDataSource) {
        
        if let index = viewModel.listProducts.firstIndex(of: data) {
            viewModel.listProducts.remove(at: index)
        }
        
        self.tableView.reloadData()
    }
}
