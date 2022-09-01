//
//  SignInViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit
import Material

class SignInViewController: BaseViewController, UITextFieldDelegate {
    
    private let viewModel   = SignInViewModel()
    let emailTxt            = ErrorTextField()
    let passwordTxt         = ErrorTextField()
    
    var isSignIn            = true
    
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
        childVỉew.backgroundColor = UIColor.init(hexString: "1890FF")?.withAlphaComponent(0.2)
        childVỉew.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(20)
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        let stackView   = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.spacing   = 30.0
        childVỉew.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            //            $0.bottom.equalToSuperview().offset(-50)
            $0.top.equalToSuperview().offset(20)
            //            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        let signInLabel = UILabel()
        signInLabel.textAlignment = .center
        signInLabel.font = getFontSize(size: 24, weight: .bold)
        signInLabel.textColor = kDefaultTextColor
        signInLabel.text = isSignIn ? "Sign in" : "Sign up"
        childVỉew.addSubview(signInLabel)
        signInLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        let signInSubLabel = UILabel()
        signInSubLabel.textAlignment = .center
        signInSubLabel.textColor = kDefaultTextColor
        signInSubLabel.font = getFontSize(size: 16, weight: .medium)
        signInSubLabel.text = isSignIn ? "New to CBIHS? Sign up" : "Already have an account? Sign in"
        childVỉew.addSubview(signInSubLabel)
        signInSubLabel.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        emailTxt.delegate = self
        emailTxt.placeholder = "Email"
        emailTxt.dividerNormalHeight = 0.5
        emailTxt.dividerNormalColor = kPrimaryColor
        emailTxt.errorColor = .red
        emailTxt.textColor = kDefaultTextColor
        emailTxt.keyboardType = .emailAddress
        emailTxt.autocapitalizationType = .none
        emailTxt.autocorrectionType = .no
        childVỉew.addSubview(emailTxt)
        emailTxt.snp.makeConstraints {
            $0.top.equalTo(signInSubLabel.snp.bottom).offset(30)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        passwordTxt.placeholder = "Password"
        passwordTxt.isSecureTextEntry = true
        passwordTxt.dividerNormalHeight = 0.5
        passwordTxt.dividerNormalColor = kPrimaryColor
        passwordTxt.errorColor = .red
        passwordTxt.textColor = kDefaultTextColor
        childVỉew.addSubview(passwordTxt)
        passwordTxt.snp.makeConstraints {
            $0.top.equalTo(emailTxt.snp.bottom).offset(50)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        let signInBtn = UIButton()
        signInBtn.setTitle(isSignIn ? "Sign in" : "Continue", for: .normal)
        signInBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        signInBtn.backgroundColor = kPrimaryColor
        signInBtn.layer.cornerRadius = 8
        childVỉew.addSubview(signInBtn)
        signInBtn.snp.makeConstraints {
            $0.top.equalTo(passwordTxt.snp.bottom).offset(50)
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func continueActionTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if !(emailTxt.text ?? "").isValidEmail() {
            let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                 message: "Email do not valid, please check it again", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
            return
        }
        
        if ((passwordTxt.text?.count ?? 0) < 6) {
            let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                 message: "Password do not valid, please check it again", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
            }))
            _NavController.showAlert(alertVC)
            return
        }
        
        if isSignIn {
            viewModel.signIn(email: emailTxt.text ?? "", password: passwordTxt.text ?? "") {
                let vc = SignInSuccessViewController()
                vc.centerDescInfo.text = "Congratulations,You have signed in successfully. Wish you have a nice experience."
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            viewModel.checkExists(email: emailTxt.text ?? "") {
                let vc = AccountInfoViewController()
                vc.prevScreenPass = self.passwordTxt.text ?? ""
                vc.prevEmail = self.emailTxt.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTxt {
            if !(emailTxt.text ?? "").isValidEmail() {
                emailTxt.isErrorRevealed = true
                emailTxt.error = "This email is not valid"
            } else {
                emailTxt.isErrorRevealed = false
            }
        }
    }
}
