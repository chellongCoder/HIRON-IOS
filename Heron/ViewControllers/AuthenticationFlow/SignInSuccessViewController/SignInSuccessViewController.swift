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
    let centerDesc              = UILabel()
    let centerDescInfo          = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
 
//        let backgroundImage = UIImageView(image: UIImage(named: "bg"))
//        backgroundImage.contentMode = .scaleAspectFit
//        self.view.addSubview(backgroundImage)
//        backgroundImage.snp.makeConstraints {
//            $0.left.right.top.bottom.equalToSuperview()
//        }
        
        let centerImage = UIImageView(image: UIImage(named: "auth_success"))
        centerImage.contentMode = .scaleAspectFit
        self.view.addSubview(centerImage)
        centerImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(145)
            $0.height.equalTo(157)
            $0.width.equalTo(104)
        }
        
        centerDesc.text = "Successfully!!"
        centerDesc.textAlignment = .center
        centerDesc.font = getCustomFont(size: 18, name: .bold)
        centerDesc.textColor = kDefaultTextColor
        self.view.addSubview(centerDesc)
        centerDesc.snp.makeConstraints {
            $0.top.equalTo(centerImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        centerDescInfo.text = "Congratulations,You have signed up successfully. Wish you have a nice experience."
        centerDescInfo.numberOfLines = 0
        centerDescInfo.textAlignment = .center
        centerDescInfo.font = getCustomFont(size: 13, name: .regular)
        centerDescInfo.textColor = kDefaultTextColor
        self.view.addSubview(centerDescInfo)
        centerDescInfo.snp.makeConstraints {
            $0.top.equalTo(centerDesc.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-80)
        }
        
        continueBtn.setTitle("Continue your journey", for: .normal)
        continueBtn.addTarget(self, action: #selector(updateRootVC), for: .touchUpInside)
        continueBtn.backgroundColor = kPrimaryColor
        continueBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.layer.cornerRadius = 20
        self.view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints {
            $0.top.equalTo(centerDescInfo.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-110)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func updateRootVC() {
        self.continueBtn.isUserInteractionEnabled = false
        self.viewModel.checkUserSubscriptionPlan()
    }
}
