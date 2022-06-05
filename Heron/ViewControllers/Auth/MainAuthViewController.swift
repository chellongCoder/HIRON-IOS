//
//  MainAuthViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class MainAuthViewController: BaseViewController {


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
            
            let center_image = UIImageView(image: UIImage(named: "center_img"))
            center_image.contentMode = .scaleAspectFit
            self.view.addSubview(center_image)
            center_image.snp.makeConstraints {
                $0.top.equalTo(top_logo.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(270)
            }
            
            let center_desc = UILabel()
            center_desc.text = "Access your patient history, lab results, future appointments and more."
            self.view.addSubview(center_desc)
            center_desc.snp.makeConstraints {
                $0.top.equalTo(center_image.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
            }
            
            let sign_in_btn = UIButton()
            sign_in_btn.backgroundColor = .red
            sign_in_btn.setTitle("Sign in", for: .normal)
            sign_in_btn.addTarget(self, action: #selector(sign_in_action), for: .touchUpInside)
            self.view.addSubview(sign_in_btn)
            sign_in_btn.snp.makeConstraints {
                $0.top.equalTo(center_desc.snp.bottom).offset(15)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
                $0.height.equalTo(60)
            }
            
            let sign_up_btn = UIButton()
            sign_up_btn.backgroundColor = .blue
            sign_up_btn.addTarget(self, action: #selector(sign_up_action), for: .touchUpInside)
            sign_up_btn.setTitle("Sign up", for: .normal)
            self.view.addSubview(sign_up_btn)
            sign_up_btn.snp.makeConstraints {
                $0.top.equalTo(sign_in_btn.snp.bottom).offset(15)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
                $0.height.equalTo(60)
            }
            
            
            
//            self.addNavigationBarButton(imageName: "ic-close-navi", direction: .left, action: #selector(updateRootVC))
    //        self.btnNext.stylingActive(cornerRadius: 5.0)
    //        self.imgAddIDCard.cardStyle(color: AppConfig.Color.blueBlur)
    //
    //        //setup pick TransportLicense
    //        let tapImgAddIDCard = UITapGestureRecognizer(target: self, action: #selector(actionAddIDCard(_:)))
    //        self.imgAddIDCard.addGestureRecognizer(tapImgAddIDCard)
    //        self.imgAddIDCard.isUserInteractionEnabled = true
        }

//        override func configObs() {
    //        observeLoading(vm.isLoading)
    //        observeMessage(vm.responseMsg)
    //        observeAuthorized(vm.isAuthorised)
//        }

        @objc func sign_in_action(_ sender: Any) {
            let vc = SignInViewController()
            vc.is_sign = true
            self.navigationController?.pushViewController(vc, animated: true)
    //        self.openChooseOptionSelectImage()
        }
        
        @objc func sign_up_action(_ sender: Any) {
            let vc = SignInViewController()
            vc.is_sign = false
            self.navigationController?.pushViewController(vc, animated: true)
    //        self.openChooseOptionSelectImage()
        }
}
