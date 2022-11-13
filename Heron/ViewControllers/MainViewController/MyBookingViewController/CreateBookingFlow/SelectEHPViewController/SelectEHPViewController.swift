//
//  BookingViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxSwift

class SelectEHPViewController: UIViewController {
    
    private let viewModel   = SelectEHPViewModel()
    let avatar              = UIImageView()
    let nameValueLabel      = UILabel()
    let genderValueLabel    = UILabel()
    let emailValueLabel     = UILabel()
    let phoneValueLabel     = UILabel()
    let dobValueLabel       = UILabel()
    let professionLabel     = UILabel()
    let addressLabel        = UILabel()
    
    let makeBookingBtn      = UIButton()
    
    private let disposeBag  = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        navigationItem.title = "My E-Health Profile"
        
        viewModel.controller = self
        
        let closeBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "xmark"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = closeBtn
        
        avatar.image = UIImage.init(named: "default-image")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.borderWidth = 1
        avatar.layer.cornerRadius = 8
        avatar.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        let basicInforLabel = UILabel()
        basicInforLabel.text = "Basic Information"
        basicInforLabel.textColor = kDefaultTextColor
        basicInforLabel.font = getCustomFont(size: 17, name: .semiBold)
        self.view.addSubview(basicInforLabel)
        basicInforLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Name:"
        nameLabel.textColor = kDefaultTextColor
        nameLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(basicInforLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        nameValueLabel.text = ""
        nameValueLabel.numberOfLines = 0
        nameValueLabel.textColor = kPrimaryColor
        nameValueLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(nameValueLabel)
        nameValueLabel.snp.makeConstraints { make in
            make.top.equalTo(basicInforLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX).offset(-40)
            make.right.equalToSuperview()
        }
        
        let genderInforLabel = UILabel()
        genderInforLabel.text = "Gender:"
        genderInforLabel.textColor = kDefaultTextColor
        genderInforLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(genderInforLabel)
        genderInforLabel.snp.makeConstraints { make in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        genderValueLabel.text = ""
        genderValueLabel.numberOfLines = 0
        genderValueLabel.textColor = kPrimaryColor
        genderValueLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(genderValueLabel)
        genderValueLabel.snp.makeConstraints { make in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX).offset(-40)
            make.right.equalToSuperview()
        }
        
        let emailInforLabel = UILabel()
        emailInforLabel.text = "Email:"
        emailInforLabel.textColor = kDefaultTextColor
        emailInforLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(emailInforLabel)
        emailInforLabel.snp.makeConstraints { make in
            make.top.equalTo(genderValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        emailValueLabel.text = ""
        emailValueLabel.numberOfLines = 0
        emailValueLabel.textColor = kPrimaryColor
        emailValueLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(emailValueLabel)
        emailValueLabel.snp.makeConstraints { make in
            make.top.equalTo(genderValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX).offset(-40)
            make.right.equalToSuperview()
        }
        
        let phoneInforLabel = UILabel()
        phoneInforLabel.text = "Phone Number:"
        phoneInforLabel.textColor = kDefaultTextColor
        phoneInforLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(phoneInforLabel)
        phoneInforLabel.snp.makeConstraints { make in
            make.top.equalTo(emailValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        phoneValueLabel.text = ""
        phoneValueLabel.numberOfLines = 0
        phoneValueLabel.textColor = kPrimaryColor
        phoneValueLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(phoneValueLabel)
        phoneValueLabel.snp.makeConstraints { make in
            make.top.equalTo(emailValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX).offset(-40)
            make.right.equalToSuperview()
        }
        
        let dobInforLabel = UILabel()
        dobInforLabel.text = "DOB:"
        dobInforLabel.textColor = kDefaultTextColor
        dobInforLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(dobInforLabel)
        dobInforLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        dobValueLabel.text = ""
        dobValueLabel.numberOfLines = 0
        dobValueLabel.textColor = kPrimaryColor
        dobValueLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(dobValueLabel)
        dobValueLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX).offset(-40)
            make.right.equalToSuperview()
        }
        
        let professtionLabel = UILabel()
        professtionLabel.text = "Profession:"
        professtionLabel.textColor = kDefaultTextColor
        professtionLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(professtionLabel)
        professtionLabel.snp.makeConstraints { make in
            make.top.equalTo(dobValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        professionLabel.text = ""
        professionLabel.numberOfLines = 0
        professionLabel.textColor = kPrimaryColor
        professionLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(professionLabel)
        professionLabel.snp.makeConstraints { make in
            make.top.equalTo(dobValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX).offset(-40)
            make.right.equalToSuperview()
        }
        
        let addressInforLabel = UILabel()
        addressInforLabel.text = "Address:"
        addressInforLabel.textColor = kDefaultTextColor
        addressInforLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(addressInforLabel)
        addressInforLabel.snp.makeConstraints { make in
            make.top.equalTo(professionLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        addressLabel.text = ""
        addressLabel.numberOfLines = 0
        addressLabel.textColor = kPrimaryColor
        addressLabel.font = getCustomFont(size: 12, name: .semiBold)
        self.view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(professionLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX).offset(-40)
            make.right.equalToSuperview().offset(-20)
        }
        
        makeBookingBtn.setTitle("Create Booking", for: .normal)
        makeBookingBtn.addTarget(self, action: #selector(makeBookingButtonTapped), for: .touchUpInside)
        makeBookingBtn.backgroundColor = kPrimaryColor
        makeBookingBtn.layer.cornerRadius = 8
        self.view.addSubview(makeBookingBtn)
        makeBookingBtn.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(addressLabel.snp.bottom).offset(30)
            $0.bottom.lessThanOrEqualToSuperview().offset(-30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }
        
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserEHealthProfiles()
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Binding Data
    func bindingData() {
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
                self.professionLabel.text = firstEHProfile.profession
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
                                             message: "This feature do not available right now.\nIt will available soon",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
}
