//
//  MainAuthViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 05/06/2022.
//

import UIKit

class MainAuthViewController: BaseViewController {
    
    private let contentScollView    = UIScrollView()
    private let pageControl         = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
       
        let signUpBtn = UIButton()
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.backgroundColor = .clear
        signUpBtn.titleLabel?.font = getCustomFont(size: 14, name: .semiBold)
        signUpBtn.setTitleColor(kPrimaryColor, for: .normal)
        signUpBtn.layer.cornerRadius = 20
        signUpBtn.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        self.view.addSubview(signUpBtn)
        signUpBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-70)
            make.height.equalTo(40)
        }
        
        let signInBtn = UIButton()
        signInBtn.setTitle("Sign in", for: .normal)
        signInBtn.backgroundColor = kPrimaryColor
        signInBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        signInBtn.setTitleColor(.white, for: .normal)
        signInBtn.layer.cornerRadius = 20
        signInBtn.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        self.view.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { make in
            make.bottom.equalTo(signUpBtn.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-70)
            make.height.equalTo(40)
        }
        
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = kDisableColor
        pageControl.currentPageIndicatorTintColor = kPrimaryColor
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.bottom.equalTo(signInBtn.snp.top).offset(-20)
        }
        
        let contentView = TutorialCell()
        contentScollView.addSubview(contentView)
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(120)
        }
        
        let centerImage = UIImageView(image: UIImage(named: "splash_screen"))
        centerImage.backgroundColor = UIColor.init(hexString: "C2EEEB")
        centerImage.contentMode = .scaleAspectFill
        centerImage.layer.masksToBounds = true
        self.view.addSubview(centerImage)
        centerImage.snp.makeConstraints {
            $0.center.size.equalToSuperview()
        }
        
        self.view.sendSubviewToBack(centerImage)
        
//        contentScollView.isPagingEnabled = true
//        self.view.addSubview(contentScollView)
//        contentScollView.snp.makeConstraints { make in
//            make.width.centerX.left.right.equalToSuperview()
//            make.height.equalTo(120)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func signInButtonTapped(_ sender: Any) {
        let vc = SignInViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signUpButtonTapped(_ sender: Any) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
 
