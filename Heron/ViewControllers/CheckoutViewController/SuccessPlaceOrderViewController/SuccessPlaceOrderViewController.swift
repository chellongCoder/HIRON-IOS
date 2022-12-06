//
//  SuccessPlaceOrderViewController.swift
//  Heron
//
//  Created by Luu Luc on 16/06/2022.
//

import UIKit

class SuccessPlaceOrderViewController: UIViewController {
    
    var listOrders  : [OrderDataSource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let placedIcon = UIImageView()
        placedIcon.image = UIImage.init(named: "orderplaced")
        placedIcon.contentMode = .scaleAspectFill
        self.view.addSubview(placedIcon)
        placedIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.centerX.equalToSuperview().offset(12.5)
            make.height.equalTo(157)
            make.width.equalTo(105)
        }
        
        let orderplacedTitle = UILabel()
        orderplacedTitle.text = "Order placed"
        orderplacedTitle.textColor = kDefaultTextColor
        orderplacedTitle.font = getCustomFont(size: 18, name: .bold)
        orderplacedTitle.textAlignment = .center
        self.view.addSubview(orderplacedTitle)
        orderplacedTitle.snp.makeConstraints { make in
            make.top.equalTo(placedIcon.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-60)
        }
        
        let orderplacedMessage = UILabel()
        orderplacedMessage.text = String(format: "Your order: #%@ has been received and is being processed. Please check the delivery status at My Order screen", self.listOrders.first?.code ?? "" )
        orderplacedMessage.textAlignment = .center
        orderplacedMessage.textColor = kDefaultTextColor
        orderplacedMessage.font = getCustomFont(size: 13, name: .regular)
        orderplacedMessage.numberOfLines = 0
        self.view.addSubview(orderplacedMessage)
        orderplacedMessage.snp.makeConstraints { make in
            make.top.equalTo(orderplacedTitle.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-60)
        }
        
        let viewMyOrderBtn = UIButton()
        viewMyOrderBtn.setTitle("View the order just placed", for: .normal)
        viewMyOrderBtn.backgroundColor = .white
        viewMyOrderBtn.setTitleColor(kPrimaryColor, for: .normal)
        viewMyOrderBtn.titleLabel?.font = getCustomFont(size: 14, name: .semiBold)
        viewMyOrderBtn.addTarget(self, action: #selector(viewMyBookingButtonTapped), for: .touchUpInside)
        self.view.addSubview(viewMyOrderBtn)
        viewMyOrderBtn.snp.makeConstraints { make in
            make.top.equalTo(orderplacedMessage.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview().offset(-100)
        }
        
        let continueBtn = UIButton()
        continueBtn.setTitle("Continue your journey", for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.backgroundColor = kPrimaryColor
        continueBtn.layer.cornerRadius = 20
        continueBtn.layer.borderColor = kPrimaryColor.cgColor
        continueBtn.layer.borderWidth = 1
        continueBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        continueBtn.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        self.view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { make in
            make.top.equalTo(viewMyOrderBtn.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-100)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Clear cart Data
        _CartServices.reloadCart()
    }
    
    // MARK: - Buttons
    @objc private func viewMyBookingButtonTapped() {
        self.dismiss(animated: true)
        _NavController.gotoMyOrderPage()
    }
    
    @objc private func continueButtonTapped() {
        self.dismiss(animated: true)
        _NavController.gotoProductListing()
    }
}
