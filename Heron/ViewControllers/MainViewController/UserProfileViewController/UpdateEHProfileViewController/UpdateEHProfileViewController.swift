//
//  UpdateEHProfileViewController.swift
//  Heron
//
//  Created by Luu Luc on 05/09/2022.
//

import UIKit
import RxSwift
import Material

class UpdateEHProfileViewController: BaseViewController {
    private let viewModel   = UpdateEHProfileViewModel()
    
    let avatar              = UIImageView()
    let nameLabel           = UILabel()
    let dobLabel            = UILabel()
    let genderLabel         = UILabel()
    let phoneLabel          = UILabel()
    let emailLabel          = UILabel()
    
    let professionTxt       = ErrorTextField()

    let updateBtn           = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update E-Health Profile"
        self.viewModel.controller = self
        
        self.showBackBtn()
        
        avatar.image = UIImage.init(named: "default-image")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.borderWidth = 1
        avatar.layer.cornerRadius = 8
        avatar.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.init(hexString: "F0F0F0")
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
        }
        
        nameLabel.text = "Name: "
        nameLabel.textColor = kDefaultTextColor
        nameLabel.numberOfLines = 0
        nameLabel.textColor = UIColor.init(hexString: "444444")
        nameLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        dobLabel.text = "DOB: "
        dobLabel.textColor = kDefaultTextColor
        dobLabel.numberOfLines = 0
        dobLabel.textColor = UIColor.init(hexString: "444444")
        dobLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(dobLabel)
        dobLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        genderLabel.text = "Gender: "
        genderLabel.textColor = kDefaultTextColor
        genderLabel.numberOfLines = 0
        genderLabel.textColor = UIColor.init(hexString: "444444")
        genderLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(dobLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        phoneLabel.text = "Phone number: "
        phoneLabel.textColor = kDefaultTextColor
        phoneLabel.numberOfLines = 0
        phoneLabel.textColor = UIColor.init(hexString: "444444")
        phoneLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        emailLabel.text = "Email: "
        emailLabel.textColor = kDefaultTextColor
        emailLabel.numberOfLines = 0
        emailLabel.textColor = UIColor.init(hexString: "444444")
        emailLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        professionTxt.placeholder = "Professtion: *"
        professionTxt.dividerNormalHeight = 0.5
        professionTxt.dividerNormalColor = kPrimaryColor
        professionTxt.errorColor = .red
        professionTxt.textColor = kDefaultTextColor
        self.view.addSubview(professionTxt)
        professionTxt.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).offset(-40)
        }
        
        updateBtn.setTitle("Update", for: .normal)
        updateBtn.setTitleColor(.white, for: .normal)
        updateBtn.backgroundColor = kPrimaryColor
        updateBtn.layer.cornerRadius = 8
        updateBtn.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        self.view.addSubview(updateBtn)
        updateBtn.snp.makeConstraints { make in
            make.top.equalTo(professionTxt.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        viewModel.getUserEHProfile()
    }
    
    // MARK: Binding Data
    override func bindingData() {
        _EHProfileServices.listProfiles
            .observe(on: MainScheduler.instance)
            .subscribe { listProfiles in
                if let mainProfile = listProfiles.element?.first {
                    if let avatarImageURL = URL(string: mainProfile.avatar) {
                        self.avatar.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
                    }
                    self.nameLabel.text = String(format: "Name: %@ %@", mainProfile.firstName, mainProfile.lastName)
                    self.dobLabel.text = String(format: "DOB: %@", mainProfile.dob)
                    self.genderLabel.text = String(format: "Gender: %@", (mainProfile.gender == .male) ? "Male" : "Female")
                    self.phoneLabel.text = String(format: "Phone number: %@", mainProfile.phone)
                    self.emailLabel.text = String(format: "Email : %@", mainProfile.email)
                    self.professionTxt.text = mainProfile.profession
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Button
    @objc private func updateButtonTapped() {
        guard let rootEHProfile = _EHProfileServices.listProfiles.value.first else {return}
        rootEHProfile.profession = self.professionTxt.text ?? ""
        
        self.viewModel.updateRootEHProfile(rootEHProfile)
    }
}
