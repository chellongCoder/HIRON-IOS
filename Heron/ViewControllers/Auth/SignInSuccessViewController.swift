//
//  SignInSuccessViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class SignInSuccessViewController: BaseViewController {


    //    @IBOutlet weak var btnNext: UIButton!
    //    @IBOutlet weak var btnAddIDCard: UIButton!
    //    @IBOutlet weak var imgAddIDCard: UIImageView!
        var imagePicker = UIImagePickerController()

    //    let vm = AccountViewModel()

        override func configUI() {
            let top_logo = UIImageView(image: UIImage(named: "logo"))
            top_logo.contentMode = .scaleAspectFit
            self.view.addSubview(top_logo)
            top_logo.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(70)
            }
            
            let center_image = UIImageView(image: UIImage(named: "auth_success"))
            center_image.contentMode = .scaleAspectFit
            self.view.addSubview(center_image)
            center_image.snp.makeConstraints {
                $0.top.equalTo(top_logo.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(50)
            }
            
            let center_desc = UILabel()
            center_desc.text = "SUCCESSFULLY!"
            center_desc.textAlignment = .center
            self.view.addSubview(center_desc)
            center_desc.snp.makeConstraints {
                $0.top.equalTo(center_image.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
            }
            
            let center_desc_info = UILabel()
            center_desc_info.numberOfLines = 0
            center_desc_info.text = "Congratulations,You have signed up successfully. Wish you have a nice experience."
            center_desc_info.textAlignment = .center
            self.view.addSubview(center_desc_info)
            center_desc_info.snp.makeConstraints {
                $0.top.equalTo(center_desc.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
            }
            
            let continue_btn = UIButton()
            continue_btn.backgroundColor = .red
            continue_btn.setTitle("Continue your journey", for: .normal)
//            continue_btn.addTarget(self, action: #selector(updateRootVC), for: .touchUpInside)
            self.view.addSubview(continue_btn)
            continue_btn.snp.makeConstraints {
                $0.top.equalTo(center_desc_info.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
                $0.height.equalTo(60)
            }
        }
        
    //    @objc func sign_in_action(_ sender: Any) {
    //        let vc = VC_SignIn()
    //        vc.is_sign = true
    //        self.navigationController?.pushViewController(vc, animated: true)
    ////        self.openChooseOptionSelectImage()
    //    }
    }
