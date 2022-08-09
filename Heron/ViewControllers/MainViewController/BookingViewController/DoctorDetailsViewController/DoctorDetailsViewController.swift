//
//  DoctorDetailsViewController.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import UIKit
import RxSwift

class DoctorDetailsViewController: BaseViewController {

    private let viewModel       = DoctorDetailsViewModel()
    private let doctorAvatar    = UIImageView()
    private let doctorTitle     = UILabel()
    private let starView        = UILabel()
    private let tagsViewScroll  = UIScrollView()
    private let tagsContentView = UIView()
    
    private let aboutContents   = UILabel()
    private let workExpContents = UILabel()
    private let certContents    = UILabel()
    
    private let confirmBtn      = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doctor Details"
        self.showBackBtn()
        self.viewModel.controller = self
                
        let staticHeight = (UIScreen.main.bounds.size.width)*0.5625
        
        if let avatarURL = URL(string: viewModel.doctorData.value?.user?.avatar ?? "") {
            self.doctorAvatar.setImage(url: avatarURL, placeholder: UIImage(named: "default-image")!)
        }
        doctorAvatar.contentMode = .scaleAspectFit
        contentView.addSubview(doctorAvatar)
        doctorAvatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview()
            make.bottom.equalTo(doctorAvatar.snp.top).offset(staticHeight + 50)
        }
        
        doctorTitle.font = getFontSize(size: 20, weight: .medium)
        doctorTitle.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        doctorTitle.numberOfLines = 0
        contentView.addSubview(doctorTitle)
        doctorTitle.snp.makeConstraints { make in
            make.top.equalTo(doctorAvatar.snp.bottom)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        starView.text = "★★★★★"
        starView.font = getFontSize(size: 16, weight: .medium)
        starView.textColor = UIColor.init(hexString: "F1C644")
        contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalTo(doctorTitle.snp.bottom)
            make.left.equalTo(doctorTitle)
        }
        
        tagsViewScroll.showsHorizontalScrollIndicator = false
        contentView.addSubview(tagsViewScroll)
        tagsViewScroll.snp.makeConstraints { make in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        tagsContentView.backgroundColor = .white
        tagsViewScroll.addSubview(tagsContentView)
        tagsContentView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.height.equalToSuperview()
        }
        
        let aboutTitle = UILabel()
        aboutTitle.text = "About"
        aboutTitle.textColor = kDefaultTextColor
        aboutTitle.font = getFontSize(size: 16, weight: .medium)
        contentView.addSubview(aboutTitle)
        aboutTitle.snp.makeConstraints { make in
            make.top.equalTo(tagsViewScroll.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        // About
        if let aboutAttribute = viewModel.doctorData.value?.attributeValues.first(where: { doctorAttribute in
            return doctorAttribute.attributeCode == .About
        }) {
            self.aboutContents.text = aboutAttribute.value
        }
        aboutContents.textColor = kDefaultTextColor
        aboutContents.font = getFontSize(size: 14, weight: .regular)
        aboutContents.numberOfLines = 0
        contentView.addSubview(aboutContents)
        aboutContents.snp.makeConstraints { make in
            make.top.equalTo(aboutTitle.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        let workExpTitle = UILabel()
        workExpTitle.text = "Work Experience"
        workExpTitle.textColor = kDefaultTextColor
        workExpTitle.font = getFontSize(size: 16, weight: .medium)
        contentView.addSubview(workExpTitle)
        workExpTitle.snp.makeConstraints { make in
            make.top.equalTo(aboutContents.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        // Work Expreience
        if let workExperienceAttribute = viewModel.doctorData.value?.attributeValues.first(where: { doctorAttribute in
            return doctorAttribute.attributeCode == .WorkExperience
        }) {
            self.workExpContents.text = workExperienceAttribute.value
        }
        workExpContents.textColor = kDefaultTextColor
        workExpContents.font = getFontSize(size: 14, weight: .regular)
        workExpContents.numberOfLines = 0
        contentView.addSubview(workExpContents)
        workExpContents.snp.makeConstraints { make in
            make.top.equalTo(workExpTitle.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        let certificateTitle = UILabel()
        certificateTitle.text = "Certificate"
        certificateTitle.textColor = kDefaultTextColor
        certificateTitle.font = getFontSize(size: 16, weight: .medium)
        contentView.addSubview(certificateTitle)
        certificateTitle.snp.makeConstraints { make in
            make.top.equalTo(workExpContents.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        // Certificates
        if let certificateAttribute = viewModel.doctorData.value?.attributeValues.first(where: { doctorAttribute in
            return doctorAttribute.attributeCode == .Certificate
        }) {
            self.certContents.text = certificateAttribute.value
        }
        certContents.textColor = kDefaultTextColor
        certContents.font = getFontSize(size: 14, weight: .regular)
        certContents.numberOfLines = 0
        contentView.addSubview(certContents)
        certContents.snp.makeConstraints { make in
            make.top.equalTo(certificateTitle.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-60)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }

        confirmBtn.setTitle("Make Appointment Now", for: .normal)
        confirmBtn.backgroundColor = kPrimaryColor
        confirmBtn.layer.cornerRadius = 8
        confirmBtn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        bottomView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Buttons
    @objc private func confirmButtonTapped() {
        let selectDateVC = SelectDateAndTimeBookingViewController()
        self.navigationController?.pushViewController(selectDateVC, animated: true)
    }
    
    // MARK: - Data
    func setDoctorDataSource(_ doctorData: DoctorDataSource) {
        self.viewModel.doctorData.accept(doctorData)
    }
    
    override func bindingData() {
        viewModel.doctorData
            .observe(on: MainScheduler.instance)
            .subscribe { doctorData in
                guard let doctorDataA = doctorData.element else {return}
                guard let doctorData = doctorDataA else {return}
                
                if let avatarURL = URL(string: doctorData.user?.avatar ?? "") {
                    self.doctorAvatar.setImage(url: avatarURL, placeholder: UIImage(named: "default-image")!)
                }
                
                if let user = doctorData.user {
                    self.doctorTitle.text = user.firstName + " " + user.lastName
                }
                self.loadTagsContents()
                
                // About
                if let aboutAttribute = doctorData.attributeValues.first(where: { doctorAttribute in
                    return doctorAttribute.attributeCode == .About
                }) {
                    self.aboutContents.text = aboutAttribute.value
                }
                
                // Work Expreience
                if let workExperienceAttribute = doctorData.attributeValues.first(where: { doctorAttribute in
                    return doctorAttribute.attributeCode == .WorkExperience
                }) {
                    self.workExpContents.text = workExperienceAttribute.value
                }
                
                // Certificates
                if let certificateAttribute = doctorData.attributeValues.first(where: { doctorAttribute in
                    return doctorAttribute.attributeCode == .Certificate
                }) {
                    self.certContents.text = certificateAttribute.value
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func loadTagsContents() {
        
        for subView in tagsContentView.subviews {
            subView.removeFromSuperview()
        }
        
        guard let doctorData = self.viewModel.doctorData.value else {return}
        
        var lastView : UIView?
        
        // Name deparment
        for teamMemberPosition in doctorData.teamMemberPosition {
            if let deparment = teamMemberPosition.team?.department {
                let newChipView = ChipView.init(title: deparment.name)
                newChipView.backgroundColor = kRedHightLightColor
                newChipView.borderColor = kRedHightLightColor
                newChipView.textLabel.textColor = .white
                tagsContentView.addSubview(newChipView)
                
                if let lastView = lastView {
                    newChipView.snp.makeConstraints { make in
                        make.centerY.top.bottom.equalToSuperview()
                        make.left.equalTo(lastView.snp.right).offset(10)
                    }
                } else {
                    newChipView.snp.makeConstraints { make in
                        make.centerY.top.bottom.equalToSuperview()
                        make.left.equalToSuperview().offset(10)
                    }
                }
                
                lastView = newChipView
            }
        }
        
        // Experience
        if let expAtribute = doctorData.attributeValues.first(where: { doctorAttribute in
            return doctorAttribute.attributeCode == .Experience
        }) {
            let newChipView = ChipView.init(title: expAtribute.value)
            newChipView.backgroundColor = kPrimaryColor
            newChipView.borderColor = kPrimaryColor
            newChipView.textLabel.textColor = .white
            tagsContentView.addSubview(newChipView)
            
            if let lastView = lastView {
                newChipView.snp.makeConstraints { make in
                    make.centerY.top.bottom.equalToSuperview()
                    make.left.equalTo(lastView.snp.right).offset(10)
                }
            } else {
                newChipView.snp.makeConstraints { make in
                    make.centerY.top.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(10)
                }
            }
            
            lastView = newChipView
        }
        
        // Dean
        if let expAtribute = doctorData.attributeValues.first(where: { doctorAttribute in
            return doctorAttribute.attributeCode == .Dean
        }) {
            let newChipView = ChipView.init(title: expAtribute.value)
            newChipView.backgroundColor = kPrimaryColor
            newChipView.borderColor = kPrimaryColor
            newChipView.textLabel.textColor = .white
            tagsContentView.addSubview(newChipView)
            
            if let lastView = lastView {
                newChipView.snp.makeConstraints { make in
                    make.centerY.top.bottom.equalToSuperview()
                    make.left.equalTo(lastView.snp.right).offset(10)
                }
            } else {
                newChipView.snp.makeConstraints { make in
                    make.centerY.top.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(10)
                }
            }
            
            lastView = newChipView
        }
        
        lastView?.snp.makeConstraints({ make in
            make.right.lessThanOrEqualToSuperview().offset(-10)
        })
    }
}
