//
//  BookingSuccessViewController.swift
//  Heron
//
//  Created by Luu Luc on 09/08/2022.
//

import UIKit

class BookingSuccessViewController: UIViewController {
    
    let orderplacedMessage = UILabel()

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
        orderplacedTitle.text = "Booking confirmed!"
        orderplacedTitle.textColor = kPrimaryColor
        orderplacedTitle.font = getCustomFont(size: 20, name: .medium)
        orderplacedTitle.textAlignment = .center
        self.view.addSubview(orderplacedTitle)
        orderplacedTitle.snp.makeConstraints { make in
            make.top.equalTo(placedIcon.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-60)
        }
        
        orderplacedMessage.textAlignment = .center
        orderplacedMessage.textColor = kDefaultTextColor
        orderplacedMessage.font = getCustomFont(size: 14, name: .regular)
        orderplacedMessage.numberOfLines = 0
        self.view.addSubview(orderplacedMessage)
        orderplacedMessage.snp.makeConstraints { make in
            make.top.equalTo(orderplacedTitle.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-60)
        }
        
        let viewMyBookingBtn = UIButton()
        viewMyBookingBtn.setTitle("View My Bookings", for: .normal)
        viewMyBookingBtn.setTitleColor(kPrimaryColor, for: .normal)
        viewMyBookingBtn.backgroundColor = .white
        viewMyBookingBtn.layer.cornerRadius = 8
        viewMyBookingBtn.layer.borderColor = kPrimaryColor.cgColor
        viewMyBookingBtn.layer.borderWidth = 1
        viewMyBookingBtn.addTarget(self, action: #selector(viewMyBookingButtonTapped), for: .touchUpInside)
        self.view.addSubview(viewMyBookingBtn)
        viewMyBookingBtn.snp.makeConstraints { make in
            make.top.equalTo(orderplacedMessage.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-100)
        }
        
        let continueBtn = UIButton()
        continueBtn.setTitle("Continue your journey", for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.backgroundColor = kPrimaryColor
        continueBtn.layer.cornerRadius = 8
        continueBtn.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        self.view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { make in
            make.top.equalTo(viewMyBookingBtn.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-100)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Buttons
    @objc private func viewMyBookingButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func continueButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        _NavController.gotoHomepage()
    }
}
