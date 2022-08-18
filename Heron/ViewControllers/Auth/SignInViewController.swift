//
//  SignInViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class SignInViewController: BaseViewController {

        var imagePicker = UIImagePickerController()
        var isSign = true
        
        let email_tf = UITextField()
        let pass_tf = UITextField()

        let vm = AuthViewModel()

        override func configUI() {
            let backgroundImage = UIImageView(image: UIImage(named: "bg"))
            backgroundImage.contentMode = .scaleAspectFit
            self.view.addSubview(backgroundImage)
            backgroundImage.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            
            let backBtn = UIButton()
            backBtn.setBackgroundImage(UIImage.init(systemName: "chevron.backward"), for: .normal)
            backBtn.tintColor = kPrimaryColor
            backBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            self.view.addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(30)
                make.width.equalTo(40)
            }
            
            let child_vỉew = UIView()
            self.view.addSubview(child_vỉew)
            child_vỉew.layer.cornerRadius = 25
            child_vỉew.backgroundColor = UIColor.init(hexString: "1890FF")?.withAlphaComponent(0.2)
            child_vỉew.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(20)
                $0.height.equalToSuperview().multipliedBy(0.7)
            }
            
            let stack_view   = UIStackView()
            stack_view.axis  = .vertical
            stack_view.distribution  = .fillEqually
            stack_view.alignment = .center
            stack_view.spacing   = 10.0
            child_vỉew.addSubview(stack_view)
            stack_view.snp.makeConstraints {
                $0.left.right.equalToSuperview()
    //            $0.bottom.equalToSuperview().offset(-50)
                $0.top.equalToSuperview().offset(20)
    //            $0.width.equalToSuperview().multipliedBy(0.5)
            }
            
            let sign_in_lbl = UILabel()
            sign_in_lbl.text = isSign ? "Sign in" : "Sign up"
            
            let sign_up_lbl = UILabel()
            sign_up_lbl.text = isSign ? "New to CBIHS? Sign up" : "Already have an account? Sign in"
            
    //        email_tf.stylingBlueBorder()
            email_tf.placeholder = "Email"
            
    //        pass_tf.stylingBlueBorder()
            pass_tf.placeholder = "Password"
            pass_tf.isSecureTextEntry = true
            
            let sign_in_btn = UIButton()
            sign_in_btn.setTitle(isSign ? "Sign in" : "Continue", for: .normal)
            sign_in_btn.addTarget(self, action: #selector(continue_action), for: .touchUpInside)
           
            stack_view.addArrangedSubview(sign_in_lbl)
            stack_view.addArrangedSubview(sign_up_lbl)
            stack_view.addArrangedSubview(email_tf)
            stack_view.addArrangedSubview(pass_tf)
            stack_view.addArrangedSubview(sign_in_btn)
            
            email_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            pass_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            sign_in_btn.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.5)
            }
           
            
            
//            self.addNavigationBarButton(imageName: "ic-back-navi", direction: .left, action: #selector(back))
    //        self.btnNext.stylingActive(cornerRadius: 5.0)
    //        self.imgAddIDCard.cardStyle(color: AppConfig.Color.blueBlur)
    //
    //        //setup pick TransportLicense
    //        let tapImgAddIDCard = UITapGestureRecognizer(target: self, action: #selector(actionAddIDCard(_:)))
    //        self.imgAddIDCard.addGestureRecognizer(tapImgAddIDCard)
    //        self.imgAddIDCard.isUserInteractionEnabled = true
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        email_tf.text = "administrator"
        pass_tf.text = "super_admin@123./"
    }
        
        @objc func continue_action(_ sender: Any) {
            if isSign {
                vm.sign_in(email: email_tf.text ?? "", password: pass_tf.text ?? "") {
                    let vc = SignInSuccessViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                vm.check_exists(email: email_tf.text ?? "", password: pass_tf.text ?? "") {
                    let vc = AccountInfoViewController()
                    vc.prev_screen_pass = self.pass_tf.text ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
    //        self.openChooseOptionSelectImage()
        }
        
//        override func configObs() {
//            observeLoading(vm.isLoading)
//            observeMessage(vm.responseMsg)
//            observeAuthorized(vm.isAuthorised)
//        }
    }
