//
//  BookingViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxSwift

class BookingViewController: BaseViewController {
    
    private let viewModel   = BookingViewModel()
    let avatar              = UIImageView()
    let nameValueLabel      = UILabel()
    let genderValueLabel    = UILabel()
    let emailValueLabel     = UILabel()
    let phoneValueLabel     = UILabel()
    let dobValueLabel       = UILabel()
    
    let makeBookingBtn      = UIButton()
    let updateEHPBtn        = UIButton()
    let myBookingBtn        = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "Booking"
        
        viewModel.controller = self
        
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
        basicInforLabel.font = getFontSize(size: 13, weight: .semibold)
        self.view.addSubview(basicInforLabel)
        basicInforLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.textColor = kDefaultTextColor
        nameLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(basicInforLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        nameValueLabel.text = ""
        nameValueLabel.numberOfLines = 0
        nameValueLabel.textColor = kPrimaryColor
        nameValueLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(nameValueLabel)
        nameValueLabel.snp.makeConstraints { make in
            make.top.equalTo(basicInforLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX)
            make.right.equalToSuperview()
        }
        
        let genderInforLabel = UILabel()
        genderInforLabel.text = "Gender"
        genderInforLabel.textColor = kDefaultTextColor
        genderInforLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(genderInforLabel)
        genderInforLabel.snp.makeConstraints { make in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        genderValueLabel.text = ""
        genderValueLabel.numberOfLines = 0
        genderValueLabel.textColor = kPrimaryColor
        genderValueLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(genderValueLabel)
        genderValueLabel.snp.makeConstraints { make in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX)
            make.right.equalToSuperview()
        }
        
        let emailInforLabel = UILabel()
        emailInforLabel.text = "Email"
        emailInforLabel.textColor = kDefaultTextColor
        emailInforLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(emailInforLabel)
        emailInforLabel.snp.makeConstraints { make in
            make.top.equalTo(genderValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        emailValueLabel.text = ""
        emailValueLabel.numberOfLines = 0
        emailValueLabel.textColor = kPrimaryColor
        emailValueLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(emailValueLabel)
        emailValueLabel.snp.makeConstraints { make in
            make.top.equalTo(genderValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX)
            make.right.equalToSuperview()
        }
        
        let phoneInforLabel = UILabel()
        phoneInforLabel.text = "Phone Number"
        phoneInforLabel.textColor = kDefaultTextColor
        phoneInforLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(phoneInforLabel)
        phoneInforLabel.snp.makeConstraints { make in
            make.top.equalTo(emailValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        phoneValueLabel.text = ""
        phoneValueLabel.numberOfLines = 0
        phoneValueLabel.textColor = kPrimaryColor
        phoneValueLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(phoneValueLabel)
        phoneValueLabel.snp.makeConstraints { make in
            make.top.equalTo(emailValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX)
            make.right.equalToSuperview()
        }
        
        let dobInforLabel = UILabel()
        dobInforLabel.text = "DOB"
        dobInforLabel.textColor = kDefaultTextColor
        dobInforLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(dobInforLabel)
        dobInforLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        dobValueLabel.text = ""
        dobValueLabel.numberOfLines = 0
        dobValueLabel.textColor = kPrimaryColor
        dobValueLabel.font = getFontSize(size: 11, weight: .semibold)
        self.view.addSubview(dobValueLabel)
        dobValueLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.centerX)
            make.right.equalToSuperview()
        }
        
        makeBookingBtn.setTitle("Create Booking", for: .normal)
        makeBookingBtn.addTarget(self, action: #selector(makeBookingButtonTapped), for: .touchUpInside)
        makeBookingBtn.backgroundColor = kPrimaryColor
        makeBookingBtn.layer.cornerRadius = 8
        self.view.addSubview(makeBookingBtn)
        makeBookingBtn.snp.makeConstraints {
            $0.top.equalTo(dobValueLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }
        
        updateEHPBtn.setTitle("Update E-Health Profile", for: .normal)
        updateEHPBtn.addTarget(self, action: #selector(updateEHPButtonTapped), for: .touchUpInside)
        updateEHPBtn.setTitleColor(kPrimaryColor, for: .normal)
        updateEHPBtn.backgroundColor = .white
        updateEHPBtn.layer.borderColor = kPrimaryColor.cgColor
        updateEHPBtn.layer.borderWidth = 1
        updateEHPBtn.layer.cornerRadius = 8
        self.view.addSubview(updateEHPBtn)
        updateEHPBtn.snp.makeConstraints {
            $0.top.equalTo(makeBookingBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }
        
        myBookingBtn.setTitle("My Bookings", for: .normal)
        myBookingBtn.addTarget(self, action: #selector(viewMyBookingsButtonTapped), for: .touchUpInside)
        myBookingBtn.setTitleColor(kPrimaryColor, for: .normal)
        myBookingBtn.backgroundColor = .white
        myBookingBtn.layer.borderColor = kPrimaryColor.cgColor
        myBookingBtn.layer.borderWidth = 1
        myBookingBtn.layer.cornerRadius = 8
        self.view.addSubview(myBookingBtn)
        myBookingBtn.snp.makeConstraints {
            $0.top.equalTo(updateEHPBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        _NavController.setNavigationBarHidden(true, animated: false)
        viewModel.getUserEHealthProfiles()
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
                self.dobValueLabel.text = firstEHProfile.dob
                
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
        _NavController.pushViewController(selectDepartmentVC, animated: true)
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
    
    @objc private func viewMyBookingsButtonTapped() {
        let myAppoimentVC = MyAppointmentViewController()
        _NavController.pushViewController(myAppoimentVC, animated: true)
    }
}
