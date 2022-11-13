//
//  MainAuthViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class MainAuthViewController: BaseViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            let topLogo = UIImageView(image: UIImage(named: "logo"))
            topLogo.contentMode = .scaleAspectFit
            self.view.addSubview(topLogo)
            topLogo.snp.makeConstraints {
                $0.top.equalToSuperview().offset(70)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(70)
            }
            
            let centerImage = UIImageView(image: UIImage(named: "splash_screen"))
            centerImage.contentMode = .scaleAspectFit
            self.view.addSubview(centerImage)
            centerImage.snp.makeConstraints {
                $0.top.equalTo(topLogo.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().offset(-40)
            }
            
            let centerDesc = UILabel()
            centerDesc.textAlignment = .center
            centerDesc.text = "Access your patient history, lab results, future appointments and more."
            centerDesc.font = getCustomFont(size: 16, name: .regular)
            centerDesc.numberOfLines = 0
            self.view.addSubview(centerDesc)
            centerDesc.snp.makeConstraints {
                $0.top.equalTo(centerImage.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().offset(-40)
            }
            
            let signInBtn = UIButton()
            signInBtn.setTitle("Sign in", for: .normal)
            signInBtn.backgroundColor = kPrimaryColor
            signInBtn.layer.cornerRadius = 8
            signInBtn.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
            self.view.addSubview(signInBtn)
            signInBtn.snp.makeConstraints {
                $0.top.equalTo(centerDesc.snp.bottom).offset(15)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().offset(-60)
                $0.height.equalTo(50)
            }
            
            let signUpBtn = UIButton()
            signUpBtn.setTitle("Sign Up", for: .normal)
            signUpBtn.setTitleColor(kDefaultTextColor, for: .normal)
            signUpBtn.backgroundColor = UIColor.init(hexString: "E5E5E5")
            signUpBtn.layer.cornerRadius = 8
            signUpBtn.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
            self.view.addSubview(signUpBtn)
            signUpBtn.snp.makeConstraints {
                $0.top.equalTo(signInBtn.snp.bottom).offset(15)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().offset(-60)
                $0.height.equalTo(50)
            }
        }

        @objc func signInButtonTapped(_ sender: Any) {
            let vc = SignInViewController()
            vc.isSignIn = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func signUpButtonTapped(_ sender: Any) {
            let vc = SignInViewController()
            vc.isSignIn = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
}
