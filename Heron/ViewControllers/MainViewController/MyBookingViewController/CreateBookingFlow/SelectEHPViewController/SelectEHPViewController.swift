//
//  BookingViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxSwift

class SelectEHPViewController: PageScrollViewController {
    
    private let viewModel   = SelectEHPViewModel()
    let avatar              = UIImageView()
    let nameValueLabel      = UILabel()
    let genderValueLabel    = UILabel()
    let emailValueLabel     = UILabel()
    let phoneValueLabel     = UILabel()
    let dobValueLabel       = UILabel()
    let addressLabel        = UILabel()
    
    let makeBookingBtn      = UIButton()
    let updateEHPBtn        = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: "ffffff")
        self.edgesForExtendedLayout = []
        navigationItem.title = "Select E-Health Profile"
        
        viewModel.controller = self
        
        let closeBtn = UIBarButtonItem.init(image: UIImage.init(named: "close_bar_icon"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = closeBtn
        
        updateEHPBtn.setTitle("Update E-health profile", for: .normal)
        updateEHPBtn.setTitleColor(kDefaultTextColor, for: .normal)
        updateEHPBtn.titleLabel?.font = getCustomFont(size: 14, name: .light)
        updateEHPBtn.addTarget(self, action: #selector(updateEHPButtonTapped), for: .touchUpInside)
        self.view.addSubview(updateEHPBtn)
        updateEHPBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(36)
        }
        
        makeBookingBtn.setTitle("Create Booking", for: .normal)
        makeBookingBtn.addTarget(self, action: #selector(makeBookingButtonTapped), for: .touchUpInside)
        makeBookingBtn.backgroundColor = kPrimaryColor
        makeBookingBtn.titleLabel?.font = getCustomFont(size: 15, name: .bold)
        makeBookingBtn.setTitleColor(.white, for: .normal)
        makeBookingBtn.layer.cornerRadius = 18
        self.view.addSubview(makeBookingBtn)
        makeBookingBtn.snp.makeConstraints { make in
            make.bottom.equalTo(updateEHPBtn.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(36)
        }
        
        pageScroll.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(makeBookingBtn.snp.top).offset(-10)
        }
        
        let avatarView = UIView()
        avatarView.backgroundColor = .white
        avatarView.layer.borderWidth = 0.7
        avatarView.layer.borderColor = kPrimaryColor.cgColor
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 60
        self.contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        avatar.image = UIImage.init(named: "default-image")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = 47
        avatarView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(94)
        }
        
        nameValueLabel.text = ""
        nameValueLabel.numberOfLines = 1
        nameValueLabel.textAlignment = .center
        nameValueLabel.textColor = kTitleTextColor
        nameValueLabel.font = getCustomFont(size: 15, name: .extraBold)
        self.contentView.addSubview(nameValueLabel)
        nameValueLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
                
        let ehpContentView = UIView()
        ehpContentView.backgroundColor = UIColor.init(hexString: "f5f7f9")!
        ehpContentView.layer.cornerRadius = 24
        self.contentView.addSubview(ehpContentView)
        ehpContentView.snp.makeConstraints { make in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        let emailInforLabel = UILabel()
        emailInforLabel.text = "Email:"
        emailInforLabel.textColor = kDefaultTextColor
        emailInforLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(emailInforLabel)
        emailInforLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        emailValueLabel.text = ""
        emailValueLabel.textAlignment = .right
        emailValueLabel.numberOfLines = 0
        emailValueLabel.textColor = kValueTextColor
        emailValueLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(emailValueLabel)
        emailValueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.greaterThanOrEqualTo(emailInforLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        let line1 = UIView()
        line1.backgroundColor = kLightGrayColor
        ehpContentView.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.top.equalTo(emailValueLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(0.5)
        }
        
        let dobInforLabel = UILabel()
        dobInforLabel.text = "DOB:"
        dobInforLabel.textColor = kDefaultTextColor
        dobInforLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(dobInforLabel)
        dobInforLabel.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        dobValueLabel.text = ""
        dobValueLabel.numberOfLines = 0
        dobValueLabel.textAlignment = .right
        dobValueLabel.textColor = kValueTextColor
        dobValueLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(dobValueLabel)
        dobValueLabel.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(16)
            make.left.greaterThanOrEqualTo(dobInforLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        let line2 = UIView()
        line2.backgroundColor = kLightGrayColor
        ehpContentView.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.top.equalTo(dobValueLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(0.5)
        }
    
        let genderInforLabel = UILabel()
        genderInforLabel.text = "Gender:"
        genderInforLabel.textColor = kDefaultTextColor
        genderInforLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(genderInforLabel)
        genderInforLabel.snp.makeConstraints { make in
            make.top.equalTo(line2.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
        }

        genderValueLabel.text = ""
        genderValueLabel.numberOfLines = 0
        genderValueLabel.textAlignment = .right
        genderValueLabel.textColor = kValueTextColor
        genderValueLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(genderValueLabel)
        genderValueLabel.snp.makeConstraints { make in
            make.top.equalTo(line2.snp.bottom).offset(16)
            make.left.greaterThanOrEqualTo(genderInforLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        let line3 = UIView()
        line3.backgroundColor = kLightGrayColor
        ehpContentView.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.top.equalTo(genderValueLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(0.5)
        }

        let phoneInforLabel = UILabel()
        phoneInforLabel.text = "Phone Number:"
        phoneInforLabel.textColor = kDefaultTextColor
        phoneInforLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(phoneInforLabel)
        phoneInforLabel.snp.makeConstraints { make in
            make.top.equalTo(line3.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        phoneValueLabel.text = ""
        phoneValueLabel.numberOfLines = 0
        phoneValueLabel.textAlignment = .right
        phoneValueLabel.textColor = kValueTextColor
        phoneValueLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(phoneValueLabel)
        phoneValueLabel.snp.makeConstraints { make in
            make.top.equalTo(line3.snp.bottom).offset(16)
            make.left.greaterThanOrEqualTo(phoneInforLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        let line4 = UIView()
        line4.backgroundColor = kLightGrayColor
        ehpContentView.addSubview(line4)
        line4.snp.makeConstraints { make in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(0.5)
        }
        
        let addressTitle = UILabel()
        addressTitle.text = "Address:"
        addressTitle.textColor = kDefaultTextColor
        addressTitle.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(addressTitle)
        addressTitle.snp.makeConstraints { make in
            make.top.equalTo(line4.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
        }

        addressLabel.text = ""
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .right
        addressLabel.textColor = kValueTextColor
        addressLabel.font = getCustomFont(size: 15, name: .semiBold)
        ehpContentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(line4.snp.bottom).offset(16)
            make.left.greaterThanOrEqualTo(addressTitle.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-22)
        }

        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserEHealthProfiles()
    }
    
    @objc override func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Binding Data
    override func bindingData() {
        _EHProfileServices.listProfiles
            .observe(on: MainScheduler.instance)
            .subscribe { listEHProfile in
                guard let firstEHProfile = listEHProfile.first else {return}
                
                if let avatarImageURL = URL(string: firstEHProfile.avatar) {
                    self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
                }
                
                self.nameValueLabel.text = String(format: "%@ %@", firstEHProfile.firstName, firstEHProfile.lastName)
                switch firstEHProfile.gender {
                case .male:
                    self.genderValueLabel.text = "Male"
                case .female:
                    self.genderValueLabel.text = "Female"
                }
                self.emailValueLabel.text = firstEHProfile.email
                self.phoneValueLabel.text = firstEHProfile.phone
                let dateDob = Date.init(timeIntervalSince1970: TimeInterval((firstEHProfile.dob ?? 0) / 1000))
                self.dobValueLabel.text = dateDob.toString(dateFormat: "MMM dd, yyyy")
                self.addressLabel.text = firstEHProfile.addressInfo?.getAddressString() ?? ""
                
            } onError: { error in
                print("onError: %@", error.localizedDescription)
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }
            .disposed(by: self.disposeBag)

    }
    
    @objc private func makeBookingButtonTapped() {
        let selectDepartmentVC = SelectDepartmentViewController()
        self.navigationController?.pushViewController(selectDepartmentVC, animated: true)
    }
    
    @objc private func updateEHPButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature is not available at the moment.",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
}
