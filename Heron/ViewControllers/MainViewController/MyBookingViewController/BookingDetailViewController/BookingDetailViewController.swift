//
//  BookingDetailViewController.swift
//  Heron
//
//  Created by Luu Luc on 09/09/2022.
//

import UIKit
import RxSwift

class BookingDetailViewController: PageScrollViewController {

    let viewModel           = BookingDetailViewModel()
    let doctorImage         = UIImageView()
    let bookingStatus       = UILabel()
    let bookingDescriptions = UILabel()
    
    let timeableLabel       = UILabel()
    let addressBookingLabel = UILabel()
    let patientInfoLabel    = UILabel()
    let doctorInfoLabel     = UILabel()
    let totalPaymentLabel   = UILabel()
    let bookingIDLabel      = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Booking Details"
        self.showBackBtn()
        
        self.viewModel.controller = self
        
        doctorImage.image = UIImage.init(named: "default-image")
        doctorImage.contentMode = .scaleAspectFit
        doctorImage.layer.borderWidth = 1
        doctorImage.layer.cornerRadius = 8
        doctorImage.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(doctorImage)
        doctorImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(260)
        }
        
        bookingStatus.textColor = kPrimaryColor
        bookingStatus.font = getFontSize(size: 20, weight: .medium)
        bookingStatus.numberOfLines = 0
        bookingStatus.textAlignment = .center
        self.view.addSubview(bookingStatus)
        bookingStatus.snp.makeConstraints { make in
            make.top.equalTo(doctorImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        
        bookingDescriptions.textColor = kDefaultTextColor
        bookingDescriptions.font = getFontSize(size: 14, weight: .regular)
        bookingDescriptions.numberOfLines = 0
        bookingDescriptions.textAlignment = .center
        self.view.addSubview(bookingDescriptions)
        bookingDescriptions.snp.makeConstraints { make in
            make.top.equalTo(bookingStatus.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        
        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(bookingDescriptions.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        
        let timeableIcon = UIImageView()
        timeableIcon.image = UIImage.init(systemName: "timer")
        timeableIcon.tintColor = kDefaultTextColor
        contentView.addSubview(timeableIcon)
        timeableIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(13)
        }
        
        timeableLabel.textColor = kDefaultTextColor
        timeableLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(timeableLabel)
        timeableLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let addressIcon = UIImageView()
        addressIcon.image = UIImage.init(systemName: "location")
        addressIcon.tintColor = kDefaultTextColor
        contentView.addSubview(addressIcon)
        addressIcon.snp.makeConstraints { make in
            make.top.equalTo(timeableIcon.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(13)
        }
        
        addressBookingLabel.text = "HARD_CODE"
        addressBookingLabel.numberOfLines = 0
        addressBookingLabel.textColor = kDefaultTextColor
        addressBookingLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(addressBookingLabel)
        addressBookingLabel.snp.makeConstraints { make in
            make.top.equalTo(timeableLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let patientIcon = UIImageView()
        patientIcon.image = UIImage.init(systemName: "person")
        patientIcon.tintColor = kDefaultTextColor
        contentView.addSubview(patientIcon)
        patientIcon.snp.makeConstraints { make in
            make.top.equalTo(addressBookingLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(13)
        }
        
        patientInfoLabel.numberOfLines = 0
        patientInfoLabel.textColor = kDefaultTextColor
        patientInfoLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(patientInfoLabel)
        patientInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(addressBookingLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let doctorIcon = UIImageView()
        doctorIcon.image = UIImage.init(systemName: "person.badge.plus")
        doctorIcon.tintColor = kDefaultTextColor
        contentView.addSubview(doctorIcon)
        doctorIcon.snp.makeConstraints { make in
            make.top.equalTo(patientInfoLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(13)
        }
        
        doctorInfoLabel.text = "HARD_CODE"
        doctorInfoLabel.numberOfLines = 0
        doctorInfoLabel.textColor = kDefaultTextColor
        doctorInfoLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(doctorInfoLabel)
        doctorInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(patientInfoLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let paymentIcon = UIImageView()
        paymentIcon.image = UIImage.init(systemName: "creditcard")
        paymentIcon.tintColor = kDefaultTextColor
        contentView.addSubview(paymentIcon)
        paymentIcon.snp.makeConstraints { make in
            make.top.equalTo(doctorInfoLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(13)
        }
        
        totalPaymentLabel.numberOfLines = 0
        totalPaymentLabel.textColor = kDefaultTextColor
        totalPaymentLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(totalPaymentLabel)
        totalPaymentLabel.snp.makeConstraints { make in
            make.top.equalTo(doctorInfoLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        let bookingIDIcon = UIImageView()
        bookingIDIcon.image = UIImage.init(systemName: "calendar")
        bookingIDIcon.tintColor = kDefaultTextColor
        contentView.addSubview(bookingIDIcon)
        bookingIDIcon.snp.makeConstraints { make in
            make.top.equalTo(totalPaymentLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(13)
        }
        
        bookingIDLabel.numberOfLines = 0
        bookingIDLabel.textColor = kDefaultTextColor
        bookingIDLabel.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(bookingIDLabel)
        bookingIDLabel.snp.makeConstraints { make in
            make.top.equalTo(totalPaymentLabel.snp.bottom).offset(8)
            make.left.equalTo(timeableIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getMyBookingDetails()
    }
    
    override func bindingData() {
        self.viewModel.bookingData
            .observe(on: MainScheduler.instance)
            .subscribe { bookingData  in
                guard let bookingElement = bookingData.element else {return}
                guard let trueBookingData = bookingElement else {return}
                
                self.viewModel.getDoctorData()
                
                switch trueBookingData.status {
                case .PENDING:
                    self.bookingStatus.text = "Booking Pending!"
                case .CONFIRMED:
                    self.bookingStatus.text = "Booking Confirmmed!"
                case .PROCESSING:
                    self.bookingStatus.text = "Booking Processing!"
                case .COMPLETED:
                    self.bookingStatus.text = "Booking Completed!"
                case .CANCELED:
                    self.bookingStatus.text = "Booking Cancelled!"
                case .REJECTED:
                    self.bookingStatus.text = "Booking Rejected!"
                case .EXPIRED:
                    self.bookingStatus.text = "Booking Expired!"
                }
                
                self.bookingDescriptions.text = String(format: "You’re having an appointment with %@.\nYour bookingID #%@",
                                                       "HARD_CODE",
                                                       trueBookingData.code)
                
                let startTime = Date.init(timeIntervalSince1970: TimeInterval(trueBookingData.startTime/1000))
                let endTime = Date.init(timeIntervalSince1970: TimeInterval(trueBookingData.endTime/1000))
                self.timeableLabel.text = String(format: "From: %@ - To: %@. At %@",
                                                 startTime.toString(dateFormat: "HH:mm"),
                                                 endTime.toString(dateFormat: "HH:mm"),
                                                 endTime.toString(dateFormat: "MMM dd, yyyy"))
                self.addressBookingLabel.text = trueBookingData.store?.addressInfo?.getAddressString()
                
                self.patientInfoLabel.text = String(format: "Customer: %@ %@ | Gender: %@",
                                                    trueBookingData.profile?.firstName ?? "",
                                                    trueBookingData.profile?.lastName ?? "",
                                                    trueBookingData.profile?.gender == .male ? "Male" : "Female")
                self.totalPaymentLabel.text = String(format: "Total: %@",
                                                     getMoneyFormat(trueBookingData.customAmount))
                self.bookingIDLabel.text = String(format: " BookingID: #%@",
                                                  trueBookingData.code)
            }
            .disposed(by: disposeBag)

        self.viewModel.doctorData
            .observe(on: MainScheduler.instance)
            .subscribe { doctorData  in
                guard let doctor = doctorData.element else {return}
                
                if let avatarImageURL = URL(string: doctor?.user?.avatar ?? "") {
                    self.doctorImage.setImage(url: avatarImageURL, placeholder: UIImage.init(named: "default-image")!)
                }
                
                self.bookingDescriptions.text = String(format: "You’re having an appointment with %@.\nYour bookingID #%@",
                                                       (doctor?.user?.firstName ?? "") + (doctor?.user?.lastName ?? ""),
                                                       self.viewModel.bookingData.value?.code ?? "")
                
                let position = (doctor?.teamMemberPosition ?? []).filter { doctorTeamMemberPosition in
                    return doctorTeamMemberPosition.team?.departmentId == self.viewModel.bookingData.value?.departmentID
                }
                
                self.doctorInfoLabel.text = String(format: "Doctor: %@, %@",
                                                   (doctor?.user?.firstName ?? "") + (doctor?.user?.lastName ?? ""),
                                                   position.first?.team?.name ?? "")
            }
            .disposed(by: disposeBag)
    }
}
