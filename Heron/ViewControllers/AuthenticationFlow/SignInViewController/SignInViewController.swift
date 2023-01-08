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
    let emailTxt            = BoundedIconTextField()
    let passwordTxt         = BoundedIconTextField()
    let checkboxBtn         = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
        
        self.showBackBtn()
        
        let dissmissKeyboardGesture = UITapGestureRecognizer.init(target: self, action: #selector(dissmissKeyboard))
        self.view.addGestureRecognizer(dissmissKeyboardGesture)
        
        let image = UIImageView()
        image.image = UIImage.init(named: "logo")
        self.navigationItem.titleView = image
//        self.view.addSubview(image)
        image.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
//            make.left.equalToSuperview().offset(16)
//            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(107)
        }
        
        let signInLabel = UILabel()
        signInLabel.textAlignment = .left
        signInLabel.font = getCustomFont(size: 26, name: .bold)
        signInLabel.textColor = kDefaultTextColor
        signInLabel.text = "Sign in"
        self.view.addSubview(signInLabel)
        signInLabel.snp.makeConstraints { make in
//            make.top.equalTo(image.snp.bottom).offset(64)
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(28)
        }
        
        let emailLabel = UILabel()
        emailLabel.text = "Email or phone number"
        emailLabel.textAlignment = .left
        emailLabel.font = getCustomFont(size: 11, name: .light)
        emailLabel.textColor = UIColor.init(hexString: "211e22")
        self.view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(50)
            make.left.equalTo(signInLabel)
        }
        
        emailTxt.delegate = self
        emailTxt.setPlaceHolderText(" Email or phone number ")
        emailTxt.keyboardType = .emailAddress
        emailTxt.autocapitalizationType = .none
        emailTxt.autocorrectionType = .no
        self.view.addSubview(emailTxt)
        emailTxt.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview().offset(-56)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.font = getCustomFont(size: 11, name: .light)
        passwordLabel.textColor = UIColor.init(hexString: "211e22")
        passwordLabel.textAlignment = .left
        self.view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(20)
            make.left.equalTo(emailLabel)
        }
        
        let forgotBtn = UIButton()
        forgotBtn.setTitle("Forgot password", for: .normal)
        forgotBtn.titleLabel?.font = getCustomFont(size: 11, name: .italic)
        forgotBtn.setTitleColor(kPrimaryColor, for: .normal)
        self.view.addSubview(forgotBtn)
        forgotBtn.snp.makeConstraints { make in
            make.centerY.equalTo(passwordLabel)
            make.right.equalToSuperview().offset(-28)
        }
        
        passwordTxt.delegate = self
        passwordTxt.setPlaceHolderText("Password")
        passwordTxt.isSecureTextEntry = true
        passwordTxt.textColor = kDefaultTextColor
        passwordTxt.setRightIcon(UIImage.init(named: "hidden_pass_icon"))
        passwordTxt.rightAction = {
            self.passwordTxt.isSecureTextEntry = !self.passwordTxt.isSecureTextEntry
            if self.passwordTxt.isSecureTextEntry {
                self.passwordTxt.setRightIcon(UIImage.init(named: "hidden_pass_icon"))
            } else {
                self.passwordTxt.setRightIcon(UIImage.init(named: "show_pass_icon"))
            }
        }
        self.view.addSubview(passwordTxt)
        passwordTxt.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview().offset(-56)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        let userDefault = UserDefaults.standard
        if let email = userDefault.value(forKey: "savedEmail") as? String,
           let password = userDefault.value(forKey: "savedPassword") as? String {
            self.emailTxt.text = email
            self.passwordTxt.text = password
            self.checkboxBtn.isSelected = true
        }
        
        checkboxBtn.setBackgroundImage(UIImage.init(named: "checkbox_unselected"), for: .normal)
        checkboxBtn.setBackgroundImage(UIImage.init(named: "checkbox_selected"), for: .selected)
        checkboxBtn.addTarget(self, action: #selector(rememberPasswordButtonTapped), for: .touchUpInside)
        self.view.addSubview(checkboxBtn)
        checkboxBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTxt.snp.bottom).offset(20)
            make.height.width.equalTo(16)
            make.left.equalTo(passwordTxt)
        }
        
        let rememberPassword = UILabel()
        rememberPassword.text = "Remember password?"
        rememberPassword.textColor = kDefaultTextColor
        rememberPassword.numberOfLines = 0
        rememberPassword.font = getCustomFont(size: 11, name: .regular)
        self.view.addSubview(rememberPassword)
        rememberPassword.snp.makeConstraints { make in
            make.left.equalTo(checkboxBtn.snp.right).offset(8)
            make.centerY.equalTo(checkboxBtn)
            make.right.equalToSuperview().offset(-20)
        }
        
        let signInBtn = UIButton()
        signInBtn.setTitle("Sign in", for: .normal)
        signInBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        signInBtn.backgroundColor = kPrimaryColor
        signInBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        signInBtn.layer.cornerRadius = 20
        self.view.addSubview(signInBtn)
        signInBtn.snp.makeConstraints {
            $0.top.equalTo(rememberPassword.snp.bottom).offset(40)
            $0.width.equalToSuperview().offset(-56)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        let signUpBtn = UIButton()
        signUpBtn.layer.borderColor = kPrimaryColor.cgColor
        signUpBtn.layer.borderWidth = 0.7
        signUpBtn.layer.cornerRadius = 20
        signUpBtn.setTitle("Sign up", for: .normal)
        signUpBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        signUpBtn.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUpBtn.setTitleColor(kPrimaryColor, for: .normal)
        signUpBtn.backgroundColor = .white
        self.view.addSubview(signUpBtn)
        signUpBtn.snp.makeConstraints { make in
            make.top.equalTo(signInBtn.snp.bottom).offset(16)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func rememberPasswordButtonTapped() {
        self.checkboxBtn.isSelected = !self.checkboxBtn.isSelected
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
        
            viewModel.signIn(email: emailTxt.text ?? "", password: passwordTxt.text ?? "") {
                
                if self.checkboxBtn.isSelected {
                    let userDefault = UserDefaults.standard
                    userDefault.set(self.emailTxt.text!, forKey: "savedEmail")
                    userDefault.set(self.passwordTxt.text!, forKey: "savedPassword")
                } else {
                    let userDefault = UserDefaults.standard
                    userDefault.removeObject(forKey: "savedEmail")
                    userDefault.removeObject(forKey: "savedPassword")
                }
                
                let vc = SignInSuccessViewController()
                vc.centerDesc.text = "Login Success!"
                vc.centerDescInfo.text = "Congratulations! You have signed in successfully.\nWe wish you the best experience using our app! Have a good day!"
                self.navigationController?.pushViewController(vc, animated: true)
            }
//    else {
//            viewModel.checkExists(email: emailTxt.text ?? "") {
//                let vc = AccountInfoViewController()
//                vc.prevScreenPass = self.passwordTxt.text ?? ""
//                vc.prevEmail = self.emailTxt.text ?? ""
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
    
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = kLightGrayColor.cgColor
        if textField == emailTxt {
            if !(emailTxt.text ?? "").isValidEmail() {
                emailTxt.setError("This email is not valid")
            } else {
                emailTxt.setError(nil)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = kPrimaryColor.cgColor
    }
}
