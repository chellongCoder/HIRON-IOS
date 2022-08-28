//
//  SignInSuccessViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class SignInSuccessViewController: BaseViewController {
    
    private let viewModel       = SignInSuccessViewModel()
    private let continueBtn     = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
    }
    
    override func configUI() {
        let backgroundImage = UIImageView(image: UIImage(named: "bg"))
        backgroundImage.contentMode = .scaleAspectFit
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let centerImage = UIImageView(image: UIImage(named: "auth_success"))
        centerImage.contentMode = .scaleAspectFit
        self.view.addSubview(centerImage)
        centerImage.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        let centerDesc = UILabel()
        centerDesc.text = "SUCCESSFULLY!"
        centerDesc.textAlignment = .center
        centerDesc.font = getFontSize(size: 20, weight: .medium)
        centerDesc.textColor = kPrimaryColor
        self.view.addSubview(centerDesc)
        centerDesc.snp.makeConstraints {
            $0.top.equalTo(centerImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        let centerDescInfo = UILabel()
        centerDescInfo.numberOfLines = 0
        centerDescInfo.text = "Congratulations,You have signed up successfully. Wish you have a nice experience."
        centerDescInfo.textAlignment = .center
        centerDescInfo.font = getFontSize(size: 14, weight: .regular)
        self.view.addSubview(centerDescInfo)
        centerDescInfo.snp.makeConstraints {
            $0.top.equalTo(centerDesc.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-70)
        }
        
        continueBtn.setTitle("Continue your journey", for: .normal)
        continueBtn.addTarget(self, action: #selector(updateRootVC), for: .touchUpInside)
        continueBtn.backgroundColor = kPrimaryColor
        continueBtn.layer.cornerRadius = 8
        self.view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints {
            $0.top.equalTo(centerDescInfo.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func updateRootVC() {
        self.continueBtn.isUserInteractionEnabled = false
        self.viewModel.checkUserSubscriptionPlan()
    }
}
