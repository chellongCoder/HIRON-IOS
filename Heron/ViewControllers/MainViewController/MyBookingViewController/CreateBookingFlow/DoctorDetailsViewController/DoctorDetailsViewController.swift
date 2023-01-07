//
//  DoctorDetailsViewController.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import UIKit
import RxSwift

class DoctorDetailsViewController: PageScrollViewController {

    private let blueView            = UIImageView()
    private let viewModel           = DoctorDetailsViewModel()
    private let doctorAvatar        = UIImageView()
    private let doctorTitle         = UILabel()
    private let nickNamwTitle       = UILabel()
    
    private let whiteView           = UIView()
    private let starView            = UILabel()
    private let numberStarView      = UILabel()
    private let tagsContent         = UILabel()
    private let experienceTitle     = UILabel()
    
    private let aboutContents       = UILabel()
    private let workExpContents     = UILabel()
    private let certContents        = UILabel()
    
    private let reviewView          = UIView()
    private let relatedView         = UIView()
    
    private let confirmBtn          = UIButton()
    
    private let aboutTitle          = UILabel()
    private var isShowMore          = false
    private let showBtn             = UIButton()
    private let showIconBtn         = ExtendedButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doctor Details"
        self.showBackBtn()
        self.viewModel.controller = self
        
        let moreBtn = UIBarButtonItem.init(image: UIImage.init(named: "moreI_bar_icon"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(moreButtonTapped))
        self.navigationItem.rightBarButtonItem = moreBtn
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }

        confirmBtn.setTitle("Book now", for: .normal)
        confirmBtn.backgroundColor = kPrimaryColor
        confirmBtn.layer.cornerRadius = 20
        confirmBtn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        bottomView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        
        pageScroll.showsVerticalScrollIndicator = false
        self.view.addSubview(pageScroll)
        pageScroll.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.pageScroll.addSubview(refreshControl)
        
        blueView.backgroundColor = kPrimaryColor
        blueView.layer.cornerRadius = 10
        blueView.contentMode = .scaleAspectFit
        self.pageScroll.addSubview(blueView)
        blueView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(250)
        }
        
        if let avatarURL = URL(string: viewModel.doctorData.value?.user?.avatar ?? "") {
            self.doctorAvatar.setImage(url: avatarURL, placeholder: UIImage(named: "default-image")!)
        }
        doctorAvatar.contentMode = .scaleAspectFit
        doctorAvatar.layer.borderColor = UIColor.white.cgColor
        doctorAvatar.layer.borderWidth = 10
        doctorAvatar.layer.cornerRadius = 50
        blueView.addSubview(doctorAvatar)
        doctorAvatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(35)
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        doctorTitle.font = getCustomFont(size: 18.5, name: .bold)
        doctorTitle.textColor = kDefaultTextColor
        doctorTitle.numberOfLines = 0
        blueView.addSubview(doctorTitle)
        doctorTitle.snp.makeConstraints { make in
            make.top.equalTo(doctorAvatar.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        nickNamwTitle.text = "Dean"
        nickNamwTitle.font = getCustomFont(size: 13.5, name: .regular)
        nickNamwTitle.textColor = kDefaultTextColor
        blueView.addSubview(nickNamwTitle)
        nickNamwTitle.snp.makeConstraints { make in
            make.top.equalTo(doctorTitle.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 10
        whiteView.layer.borderColor = kPrimaryColor.cgColor
        whiteView.layer.borderWidth = 0.5
        self.pageScroll.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.width.equalTo(225)
            make.centerY.equalTo(blueView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(67)
        }
        
        tagsContent.text = "Cardiology"
        tagsContent.numberOfLines = 0
        tagsContent.font = getCustomFont(size: 11.5, name: .semiBold)
        tagsContent.textAlignment = .center
        tagsContent.layer.masksToBounds = true
        tagsContent.textColor = kPrimaryColor
        tagsContent.layer.cornerRadius = 10
        tagsContent.backgroundColor = UIColor.init(hexString: "ebedfb")
        whiteView.addSubview(tagsContent)
        tagsContent.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        let centerView = UIView()
        whiteView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagsContent.snp.bottom).offset(10)
        }
        
        experienceTitle.text = "5 years experience"
        experienceTitle.numberOfLines = 0
        experienceTitle.font = getCustomFont(size: 11.5, name: .regular)
        experienceTitle.textColor = kDefaultTextColor
        centerView.addSubview(experienceTitle)
        experienceTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        starView.text = "★"
        starView.font = getCustomFont(size: 10, name: .medium)
        starView.textColor = .red
        centerView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(experienceTitle.snp.right).offset(6)
//            make.right.equalTo(numberStarView.snp.left).offset(-2)
        }
        
        numberStarView.text = "4.5"
        numberStarView.font = getCustomFont(size: 11.5, name: .regular)
        numberStarView.textColor = kDefaultTextColor
        centerView.addSubview(numberStarView)
        numberStarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(starView.snp.right)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        let detailView = UIView()
        self.pageScroll.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        var lastItem : UIView?
        for index in 1...4 {
            let inforView = DoctorBasicInformationView()
            detailView.addSubview(inforView)
            inforView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
            }
            
            if lastItem == nil {
                inforView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                }
            } else {
                inforView.snp.makeConstraints { make in
                    make.top.equalTo(lastItem!.snp.bottom)
                }
            }
            
            lastItem = inforView
        }
        
        lastItem?.snp.makeConstraints({ make in
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        })
        
        let line1 = UIView()
        line1.layer.backgroundColor = kGrayColor.cgColor
        self.pageScroll.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(6)
        }
        
        aboutTitle.text = "About"
        aboutTitle.textColor = kDefaultTextColor
        aboutTitle.font = getCustomFont(size: 13.5, name: .bold)
        self.pageScroll.addSubview(aboutTitle)
        aboutTitle.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(25)
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
        aboutContents.font = getCustomFont(size: 13.5, name: .regular)
        aboutContents.numberOfLines = 0
        self.pageScroll.addSubview(aboutContents)
        aboutContents.snp.makeConstraints { make in
            make.top.equalTo(aboutTitle.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.height.lessThanOrEqualTo(100)
            make.centerX.equalToSuperview()
        }
        
        showBtn.setTitle("Show more", for: .normal)
        showBtn.titleLabel?.font = getCustomFont(size: 11.5, name: .regular)
        showBtn.setTitleColor(kDefaultTextColor, for: .normal)
        showBtn.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        self.pageScroll.addSubview(showBtn)
        showBtn.snp.makeConstraints { make in
            make.top.equalTo(aboutContents.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        showIconBtn.setImage(UIImage.init(named: "down_icon"), for: .normal)
        showIconBtn.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        self.pageScroll.addSubview(showIconBtn)
        showIconBtn.snp.makeConstraints { make in
            make.centerY.equalTo(showBtn)
            make.left.equalTo(showBtn.snp.right).offset(2)
            make.height.width.equalTo(20)
        }
        
        let line2 = UIView()
        line2.layer.backgroundColor = kGrayColor.cgColor
        self.pageScroll.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.top.equalTo(showBtn.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(6)
        }
        
        let workExpTitle = UILabel()
        workExpTitle.text = "Working Experience"
        workExpTitle.textColor = kDefaultTextColor
        workExpTitle.font = getCustomFont(size: 13.5, name: .bold)
        self.pageScroll.addSubview(workExpTitle)
        workExpTitle.snp.makeConstraints { make in
            make.top.equalTo(line2.snp.bottom).offset(20)
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
        workExpContents.font = getCustomFont(size: 13.5, name: .regular)
        workExpContents.numberOfLines = 0
        self.pageScroll.addSubview(workExpContents)
        workExpContents.snp.makeConstraints { make in
            make.top.equalTo(workExpTitle.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        let line3 = UIView()
        line3.layer.backgroundColor = kGrayColor.cgColor
        self.pageScroll.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.top.equalTo(workExpContents.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(6)
        }
        
        let certificateTitle = UILabel()
        certificateTitle.text = "Certificate"
        certificateTitle.textColor = kDefaultTextColor
        certificateTitle.font = getCustomFont(size: 13.5, name: .bold)
        self.pageScroll.addSubview(certificateTitle)
        certificateTitle.snp.makeConstraints { make in
            make.top.equalTo(line3.snp.bottom).offset(20)
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
        certContents.font = getCustomFont(size: 13.5, name: .regular)
        certContents.numberOfLines = 0
        self.pageScroll.addSubview(certContents)
        certContents.snp.makeConstraints { make in
            make.top.equalTo(certificateTitle.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        let line4 = UIView()
        line4.layer.backgroundColor = kGrayColor.cgColor
        self.pageScroll.addSubview(line4)
        line4.snp.makeConstraints { make in
            make.top.equalTo(certContents.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(6)
        }
        
        self.pageScroll.addSubview(reviewView)
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(line4.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        self.reloadReviewData()
        
        self.pageScroll.addSubview(relatedView)
        relatedView.snp.makeConstraints { make in
            make.top.equalTo(reviewView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        self.reloadRelatedDoctors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getListDoctor()
    }
    
    // MARK: - UI/UX
    
    private func reloadReviewData() {
        // Remove old reviews
        for subview in self.reviewView.subviews {
            subview.removeFromSuperview()
        }
        
        let reviewTilte = UILabel()
        reviewTilte.text = "Reviews"
        reviewTilte.font = getCustomFont(size: 13.5, name: .bold)
        reviewTilte.textColor = kDefaultTextColor
        reviewTilte.textAlignment = .left
        reviewView.addSubview(reviewTilte)
        reviewTilte.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
        }
        
        let starImage = UILabel()
        starImage.text = "★"
        starImage.font = getCustomFont(size: 11, name: .medium)
        starImage.textColor = .red
        reviewView.addSubview(starImage)
        starImage.snp.makeConstraints { make in
            make.top.equalTo(reviewTilte.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
        }
        
        let numberStar = UILabel()
        numberStar.text = "4.5"
        numberStar.font = getCustomFont(size: 13.5, name: .regular)
        numberStar.textColor = kDefaultTextColor
        reviewView.addSubview(numberStar)
        numberStar.snp.makeConstraints { make in
            make.top.equalTo(starImage)
            make.left.equalTo(starImage.snp.right).offset(2)
        }
        
        let sepraterLine = UIView()
        sepraterLine.backgroundColor = kLightGrayColor
        reviewView.addSubview(sepraterLine)
        sepraterLine.snp.makeConstraints { make in
            make.top.height.equalTo(numberStar)
            make.left.equalTo(numberStar.snp.right).offset(8)
            make.width.equalTo(0.5)
        }
        
        let totalReviews = UILabel()
        totalReviews.text = "80 reviews"
        totalReviews.font = getCustomFont(size: 13.5, name: .regular)
        totalReviews.textColor = kDefaultTextColor
        totalReviews.textAlignment = .left
        reviewView.addSubview(totalReviews)
        totalReviews.snp.makeConstraints { make in
            make.top.equalTo(sepraterLine)
            make.left.equalTo(sepraterLine.snp.right).offset(8)
        }
        
        let showReviewIconBtn = UIButton()
        showReviewIconBtn.setImage(UIImage.init(named: "right_icon"), for: .normal)
        showReviewIconBtn.addTarget(self, action: #selector(showAllButtonTapped), for: .touchUpInside)
        reviewView.addSubview(showReviewIconBtn)
        showReviewIconBtn.snp.makeConstraints { make in
            make.centerY.equalTo(totalReviews)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(24)
        }
        
        let showReviewBtn = UIButton()
        showReviewBtn.setTitle("Show all", for: .normal)
        showReviewBtn.titleLabel?.font = getCustomFont(size: 11.5, name: .regular)
        showReviewBtn.setTitleColor(kDefaultTextColor, for: .normal)
        showReviewBtn.addTarget(self, action: #selector(showAllButtonTapped), for: .touchUpInside)
        reviewView.addSubview(showReviewBtn)
        showReviewBtn.snp.makeConstraints { make in
            make.centerY.equalTo(showReviewIconBtn)
            make.right.equalTo(showReviewIconBtn.snp.left)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        var lastReviewView: UIView = showReviewBtn

        for reviewData in self.viewModel.doctorReviews.value {

            let newCell = ReviewCell()
            newCell.setDataSource(reviewData)
            self.reviewView.addSubview(newCell)
            newCell.snp.makeConstraints { make in
                make.top.equalTo(lastReviewView.snp.bottom)
                make.left.right.equalToSuperview()
            }

            lastReviewView = newCell
        }
        
        lastReviewView.snp.makeConstraints({ make in
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        })
        
    }
    
    private func reloadRelatedDoctors() {
        // Remove old reviews
        for subview in self.relatedView.subviews {
            subview.removeFromSuperview()
        }
        
        if viewModel.relatedDoctors.value.isEmpty {
            return
        }
        
        let line5 = UIView()
        line5.layer.backgroundColor = kGrayColor.cgColor
        relatedView.addSubview(line5)
        line5.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(6)
        }
        
        let relatedDoctorTitle = UILabel()
        relatedDoctorTitle.text = "Related doctor"
        relatedDoctorTitle.font = getCustomFont(size: 13.5, name: .bold)
        relatedDoctorTitle.textColor = kDefaultTextColor
        relatedDoctorTitle.textAlignment = .left
        relatedView.addSubview(relatedDoctorTitle)
        relatedDoctorTitle.snp.makeConstraints { make in
            make.top.equalTo(line5.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
        }
        
        var lastRelatedView: UIView = relatedDoctorTitle

        for doctorData in self.viewModel.relatedDoctors.value {

            let newCell = DoctorListingView()
            newCell.setDataSource(doctorData)
            self.relatedView.addSubview(newCell)
            newCell.snp.makeConstraints { make in
                make.top.equalTo(lastRelatedView.snp.bottom)
                make.left.right.equalToSuperview()
            }

            lastRelatedView = newCell
        }
        
        lastRelatedView.snp.makeConstraints({ make in
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        })
    }
    
    // MARK: - UIButton Action
    @objc private func confirmButtonTapped() {
        let selectDateVC = SelectDateAndTimeBookingViewController()
        self.navigationController?.pushViewController(selectDateVC, animated: true)
    }
    
    @objc private func moreButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature is not available at the moment.",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                             style: .default,
                                             handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
    
    @objc private func showMoreButtonTapped() {
        self.isShowMore = !self.isShowMore
        
        if self.isShowMore {
            aboutContents.snp.remakeConstraints { make in
                make.top.equalTo(aboutTitle.snp.bottom).offset(12)
                make.left.equalToSuperview().offset(16)
                make.centerX.equalToSuperview()
            }
            
            showBtn.setTitle("Show less", for: .normal)
            showIconBtn.setImage(UIImage.init(named: "up_icon"), for: .normal)
            
            self.aboutContents.layoutIfNeeded()
        } else {
            aboutContents.snp.remakeConstraints { make in
                make.top.equalTo(aboutTitle.snp.bottom).offset(12)
                make.left.equalToSuperview().offset(16)
                make.height.lessThanOrEqualTo(100)
                make.centerX.equalToSuperview()
            }
            
            showBtn.setTitle("Show more", for: .normal)
            showIconBtn.setImage(UIImage.init(named: "down_icon"), for: .normal)
            
            self.aboutContents.layoutIfNeeded()
        }
    }
    
    @objc private func showAllButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature is not available at the moment.",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                             style: .default,
                                             handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
    
    // MARK: - Data
    func setDoctorDataSource(_ doctorData: DoctorDataSource) {
        self.viewModel.doctorData.accept(doctorData)
    }
    
    override func reloadData() {
        self.refreshControl.endRefreshing()
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
        
        viewModel.doctorReviews
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.reloadReviewData()
            }
            .disposed(by: disposeBag)
        
        viewModel.relatedDoctors
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.reloadRelatedDoctors()
            }
            .disposed(by: disposeBag)
    }
}
