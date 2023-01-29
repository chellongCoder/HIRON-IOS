//
//  FilterProductViewController.swift
//  Heron
//
//  Created by Longnn on 22/01/2023.
//

import Foundation
class FilterProductViewController: BaseViewController, UIScrollViewDelegate {
    var dropdown = DropDownPicker([ "Item1",
                                    "Item2",
                                    "Item3",
                                    "Item3",
                                    "Item4"])
    var priceRangeView = PriceRange()
    var ratingPickerView = RatingPicker()
    let actionButon = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func onClick(sender: UIButton) {
        print(sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackBtn()
        self.navigationItem.title = "Filter Products"
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = getCustomFont(size: 18, name: .bold)
        resetButton.setTitleColor(kPrimaryColor, for: .normal)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: resetButton)
        
        self.view.addSubview(dropdown)
        dropdown.layer.borderWidth = 1
        dropdown.layer.borderColor = kDefaultGreyColor.cgColor
        dropdown.layer.cornerRadius = 6
        dropdown.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15.5)
        }
        
        self.view.addSubview(priceRangeView)
        priceRangeView.layer.borderWidth = 1
        priceRangeView.layer.borderColor = kDefaultGreyColor.cgColor
        priceRangeView.layer.cornerRadius = 6
        priceRangeView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.top.equalTo(dropdown.snp.bottom).offset(30)
        }
        
        self.view.addSubview(ratingPickerView)
        ratingPickerView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.top.equalTo(priceRangeView.snp.bottom).offset(30)
        }
        
        self.view.addSubview(actionButon)
        actionButon.backgroundColor = kPrimaryColor
        actionButon.setTitle("Apply", for: .normal)
        actionButon.titleLabel?.font = getCustomFont(size: 14.5, name: .bold)
        actionButon.layer.cornerRadius = 20
        actionButon.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        actionButon.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-76)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
