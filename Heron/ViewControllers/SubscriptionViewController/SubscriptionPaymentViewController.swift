//
//  SubscriptionPaymentViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import UIKit

class SubscriptionPaymentViewController: BaseViewController {
    var imagePicker = UIImagePickerController()
//            let vm = VM_Auth()

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
        stack_view.distribution  = .fillProportionally
        stack_view.alignment = .center
        stack_view.spacing   = 10.0
        child_vỉew.addSubview(stack_view)
        stack_view.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        let sign_in_lbl = UILabel()
        sign_in_lbl.text = "Your choosen plan is:"
        
        let sign_up_lbl = UILabel()
        sign_up_lbl.text = "Annually subscription"
        
        let pricelbl = UILabel()
        pricelbl.fontSize = 24
        pricelbl.text = "$ 100.00/year"
        
        
        let sign_in_btn = UIButton()
        sign_in_btn.successButton(title: "Pay")
        sign_in_btn.addTarget(self, action: #selector(continue_action), for: .touchUpInside)
        
        let hstack = UIStackView()
        hstack.axis  = .horizontal
        hstack.distribution  = .fillProportionally
        hstack.alignment = .center
        hstack.spacing = 10
        
     
        stack_view.addArrangedSubview(sign_in_lbl)
        stack_view.addArrangedSubview(sign_up_lbl)
        stack_view.addArrangedSubview(pricelbl)
        stack_view.addArrangedSubview(sign_in_btn)
        
     
        sign_in_btn.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        hstack.snp.makeConstraints {
//                    $0.width.equalToSuperview()
            $0.height.equalTo(200)
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
    
}
    
    @objc func continue_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

//        override func configObs() {
//            observeLoading(vm.isLoading)
//            observeMessage(vm.responseMsg)
//            observeAuthorized(vm.isAuthorised)
//        }
}

