//
//  SubscriptionPaymentViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import UIKit

class SubscriptionPaymentViewController: BaseViewController {
    
    override func configUI() {
        let backgroundImage = UIImageView(image: UIImage(named: "bg"))
        backgroundImage.contentMode = .scaleAspectFit
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let childVỉew = UIView()
        self.view.addSubview(childVỉew)
        childVỉew.layer.cornerRadius = 25
        childVỉew.backgroundColor = UIColor.init(hexString: "1890FF")?.withAlphaComponent(0.2)
        childVỉew.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(20)
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        let stackView   = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fillProportionally
        stackView.alignment = .center
        stackView.spacing   = 10.0
        childVỉew.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        let choosedPlanIs = UILabel()
        choosedPlanIs.text = "Your choosen plan is:"
        
        let selectedPlanName = UILabel()
        selectedPlanName.text = "Annually subscription"
        
        let pricelbl = UILabel()
        pricelbl.fontSize = 24
        pricelbl.text = "$ 100.00/year"
        
        let continueBtn = UIButton()
        continueBtn.setTitle("Pay", for: .normal)
        continueBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        
        let hstack = UIStackView()
        hstack.axis  = .horizontal
        hstack.distribution  = .fillProportionally
        hstack.alignment = .center
        hstack.spacing = 10
        
        stackView.addArrangedSubview(choosedPlanIs)
        stackView.addArrangedSubview(selectedPlanName)
        stackView.addArrangedSubview(pricelbl)
        stackView.addArrangedSubview(continueBtn)
        
        
        continueBtn.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        hstack.snp.makeConstraints {
            $0.height.equalTo(200)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func continueActionTapped(_ sender: Any) {
        _NavController.gotoHomepage()
    }
}

