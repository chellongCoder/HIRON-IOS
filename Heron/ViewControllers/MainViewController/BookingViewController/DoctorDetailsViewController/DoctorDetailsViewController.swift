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
    private let topMediaView    = UIImageView()
    private let doctorTitle     = UILabel()
    private let starView        = UILabel()
    private let tagsViewStack   = UIStackView()
    
    private let confirmBtn      = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doctos Details"
        self.showBackBtn()
        self.viewModel.controller = self
                
        let staticHeight = (UIScreen.main.bounds.size.width)*0.5625
        topMediaView.contentMode = .scaleAspectFit
        topMediaView.image = UIImage(named: "default-image")
        contentView.addSubview(topMediaView)
        topMediaView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview()
            make.bottom.equalTo(topMediaView.snp.top).offset(staticHeight + 50)
        }
        
        doctorTitle.font = getFontSize(size: 20, weight: .medium)
        doctorTitle.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        doctorTitle.numberOfLines = 0
        contentView.addSubview(doctorTitle)
        doctorTitle.snp.makeConstraints { make in
            make.top.equalTo(topMediaView.snp.bottom)
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
        
        tagsViewStack.axis  = .horizontal
        tagsViewStack.distribution  = .fillProportionally
        tagsViewStack.alignment = .center
        tagsViewStack.spacing = 10
        contentView.addSubview(tagsViewStack)
        tagsViewStack.snp.makeConstraints { make in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        
        confirmBtn.setTitle("Make Appointment Now", for: .normal)
        confirmBtn.backgroundColor = kPrimaryColor
        confirmBtn.layer.cornerRadius = 8
        confirmBtn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
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
                
                if let user = doctorData.user {
                    self.doctorTitle.text = user.firstName + " " + user.lastName
                }
                self.loadTagsContents()
            }
            .disposed(by: disposeBag)
    }
    
    private func loadTagsContents() {
        for arrangedSubview in tagsViewStack.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
        
        guard let doctorData = self.viewModel.doctorData.value else {return}
        
        for attribute in doctorData.attributeValues {
            let newChipView = ChipView()
            newChipView.setTitle(attribute.attributeCode)
            tagsViewStack.addArrangedSubview(newChipView)
        }
    }
}
