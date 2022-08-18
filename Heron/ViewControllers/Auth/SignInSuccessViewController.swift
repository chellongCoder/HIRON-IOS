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
            let backgroundImage = UIImageView(image: UIImage(named: "bg"))
            backgroundImage.contentMode = .scaleAspectFit
            self.view.addSubview(backgroundImage)
            backgroundImage.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            
            let center_image = UIImageView(image: UIImage(named: "auth_success"))
            center_image.contentMode = .scaleAspectFit
            self.view.addSubview(center_image)
            center_image.snp.makeConstraints {
                $0.centerY.equalToSuperview().offset(-50)
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
            continue_btn.setTitle("Continue your journey", for: .normal)
            continue_btn.addTarget(self, action: #selector(updateRootVC), for: .touchUpInside)
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
    //        vc.isSign = true
    //        self.navigationController?.pushViewController(vc, animated: true)
    ////        self.openChooseOptionSelectImage()
    //    }
    
    @objc func updateRootVC() {
//        mainVc.modalPresentationStyle = .overFullScreen
//        self.dismiss(animated: true, completion: nil)
        let vc = MainSubscriptionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.pushViewController(mainVc, animated: true)
    }
    }


