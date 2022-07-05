//
//  AccountInfoViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class AccountInfoViewController: BaseViewController {

        var imagePicker = UIImagePickerController()
        var isSign = true
        
        let first_name_tf = UITextField()
        let last_name_tf = UITextField()
        let gender_tf = UITextField()
        let dob_tf = UITextField()
        let email_tf = UITextField()
        let phone_number_tf = UITextField()
        
        var prev_screen_pass = ""
        
    //    let vm = AuthViewModel()

        override func configUI() {
            let bg = UIImageView(image: UIImage(named: "bg"))
            bg.contentMode = .scaleAspectFit
            self.view.addSubview(bg)
            bg.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
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
            sign_in_lbl.text = "Account Info"
         
    //        first_name_tf.stylingBlueBorder()
            first_name_tf.placeholder = "First name *"
            
    //        last_name_tf.stylingBlueBorder()
            last_name_tf.placeholder = "Last Name *"
            
    //        gender_tf.stylingBlueBorder()
            gender_tf.placeholder = "Gender *"
            
    //        dob_tf.stylingBlueBorder()
            dob_tf.placeholder = "Date of birth *"
            
    //        email_tf.stylingBlueBorder()
            email_tf.placeholder = "Email"
            
    //        phone_number_tf.stylingBlueBorder()
            phone_number_tf.placeholder = "Phone number *"
            
            let create_account_btn = UIButton()
            create_account_btn.backgroundColor = .red
            create_account_btn.addTarget(self, action: #selector(continue_action), for: .touchUpInside)
            create_account_btn.setTitle("Create", for: .normal)
           
            stack_view.addArrangedSubview(sign_in_lbl)
            stack_view.addArrangedSubview(first_name_tf)
            stack_view.addArrangedSubview(last_name_tf)
            stack_view.addArrangedSubview(gender_tf)
            stack_view.addArrangedSubview(dob_tf)
            stack_view.addArrangedSubview(email_tf)
            stack_view.addArrangedSubview(phone_number_tf)
            stack_view.addArrangedSubview(create_account_btn)
            
            first_name_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            last_name_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            gender_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            dob_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            email_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            phone_number_tf.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
            }
            create_account_btn.snp.makeConstraints {
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
        
        @objc func continue_action(_ sender: Any) {
    //        vm.sign_up(username: email_tf.text ?? "", passwd: prev_screen_pass, fitst_name: first_name_tf.text ?? "", last_name: last_name_tf.text ?? "", gender: gender_tf.text ?? "", dob: Int(dob_tf.text ?? "") ?? 0, identityNum: "1234567889", phone: phone_number_tf.text ?? "") {
    //            Defaults[.isLogged] = true
                let vc = SignInSuccessViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
    //        self.openChooseOptionSelectImage()
        }
