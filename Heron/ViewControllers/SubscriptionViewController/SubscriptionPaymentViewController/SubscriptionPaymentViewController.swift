//
//  SubscriptionPaymentViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import UIKit
import RxSwift

class SubscriptionPaymentViewController: BaseViewController {
    
    let viewModel = SubscriptionPaymentViewModel()
    
    let selectedPlanName    = UILabel()
    let pricelbl            = UILabel()
    let continueBtn         = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self

        let backgroundImage = UIImageView(image: UIImage(named: "bg"))
        backgroundImage.contentMode = .scaleAspectFit
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let backBtn = UIButton()
        backBtn.setBackgroundImage(UIImage.init(systemName: "chevron.backward"), for: .normal)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.width.equalTo(20)
        }
        
        let childVỉew = UIView()
        self.view.addSubview(childVỉew)
        childVỉew.layer.cornerRadius = 25
        childVỉew.backgroundColor = UIColor.init(hexString: "1890FF")?.withAlphaComponent(0.7)
        childVỉew.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(20)
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        let stackView   = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fillProportionally
        stackView.alignment = .center
        stackView.spacing   = 20.0
        childVỉew.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(80)
        }
                
        let choosedPlanIs = UILabel()
        choosedPlanIs.textColor = kDefaultTextColor
        choosedPlanIs.font = getFontSize(size: 16, weight: .bold)
        choosedPlanIs.text = "Your choosen plan is:"
        
        selectedPlanName.text = "Annually subscription"
        selectedPlanName.textColor = .white
        selectedPlanName.font = getFontSize(size: 20, weight: .medium)
        
        pricelbl.textColor = .white
        pricelbl.font = getFontSize(size: 24, weight: .bold)
        
        let hstack = UIStackView()
        hstack.axis  = .horizontal
        hstack.distribution  = .fillProportionally
        hstack.alignment = .center
        hstack.spacing = 10
        
        stackView.addArrangedSubview(choosedPlanIs)
        stackView.addArrangedSubview(selectedPlanName)
        stackView.addArrangedSubview(pricelbl)
        
        hstack.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        continueBtn.setTitle("Pay", for: .normal)
        continueBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        continueBtn.backgroundColor = .white
        continueBtn.setTitleColor(kPrimaryColor, for: .normal)
        continueBtn.layer.cornerRadius = 8
        childVỉew.addSubview(continueBtn)
        continueBtn.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
    
    @objc func continueActionTapped(_ sender: Any) {
//        _NavController.gotoHomepage()
        self.viewModel.checkoutSubscription()
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        self.viewModel.subscriptionPlan
            .observe(on: MainScheduler.instance)
            .subscribe { subscriptionPlan in
                guard let subscriptionPlan = subscriptionPlan.element else {return}
                guard let trueSubscriptionPlan = subscriptionPlan else {return}
                self.selectedPlanName.text = trueSubscriptionPlan.subsItem?.name
                if trueSubscriptionPlan.interval_count == 1 {
                    self.pricelbl.text = String(format: "%@ / %@",
                                                getMoneyFormat(trueSubscriptionPlan.customFinalPrice),
                                                trueSubscriptionPlan.interval.rawValue)
                } else {
                    self.pricelbl.text = String(format: "%@ per %ld %@s",
                                                getMoneyFormat(trueSubscriptionPlan.customFinalPrice),
                                                trueSubscriptionPlan.interval_count,
                                                trueSubscriptionPlan.interval.rawValue)
                }
                
            }
            .disposed(by: disposeBag)

    }
}
