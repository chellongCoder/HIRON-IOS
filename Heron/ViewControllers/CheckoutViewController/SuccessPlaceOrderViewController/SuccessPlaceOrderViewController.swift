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
            make.top.equalToSuperview().offset(90)
            make.centerX.equalToSuperview()
            make.height.equalTo(174)
            make.width.equalTo(210)
        }
        
        let orderplacedTitle = UILabel()
        orderplacedTitle.text = "Order placed"
        orderplacedTitle.textColor = kPrimaryColor
        orderplacedTitle.font = getFontSize(size: 20, weight: .medium)
        orderplacedTitle.textAlignment = .center
        self.view.addSubview(orderplacedTitle)
        orderplacedTitle.snp.makeConstraints { make in
            make.top.equalTo(placedIcon.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-60)
        }
        
        let orderplacedMessage = UILabel()
        orderplacedMessage.text = "Your order has been received and is being processed. Please check the delivery status at My Orther page"
        orderplacedMessage.textAlignment = .center
        orderplacedMessage.textColor = kDefaultTextColor
        orderplacedMessage.font = getFontSize(size: 14, weight: .regular)
        orderplacedMessage.numberOfLines = 0
        self.view.addSubview(orderplacedMessage)
        orderplacedMessage.snp.makeConstraints { make in
            make.top.equalTo(orderplacedTitle.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-60)
        }
        
        let viewMyOrderBtn = UIButton()
        viewMyOrderBtn.setTitle("View  My Order", for: .normal)
        viewMyOrderBtn.backgroundColor = kPrimaryColor
        viewMyOrderBtn.layer.cornerRadius = 8
        viewMyOrderBtn.addTarget(self, action: #selector(viewMyBookingButtonTapped), for: .touchUpInside)
        self.view.addSubview(viewMyOrderBtn)
        viewMyOrderBtn.snp.makeConstraints { make in
            make.top.equalTo(orderplacedMessage.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-100)
        }
        
        let continueBtn = UIButton()
        continueBtn.setTitle("Continue your journey", for: .normal)
        continueBtn.setTitleColor(kPrimaryColor, for: .normal)
        continueBtn.backgroundColor = .white
        continueBtn.layer.cornerRadius = 8
        continueBtn.layer.borderColor = kPrimaryColor.cgColor
        continueBtn.layer.borderWidth = 1
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
        _CartServices.voucherCode.accept(nil)
    }
    
    // MARK: - Buttons
    @objc private func viewMyBookingButtonTapped() {
        _NavController.gotoMyOrderPage()
    }
    
    @objc private func continueButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
