//
//  SelectDoctorTableViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

protocol SelectDoctorCellDelegate : AnyObject {
    func bookNow(_ indexPath: Int)
}

class SelectDoctorTableViewCell: UITableViewCell {
    
    private let doctorAvatar        = UIImageView()
    private let doctorNameLabel     = UILabel()
    private let heartView           = UIImageView()
    private let addressLabel        = UILabel()
    private let tagsContent         = UILabel()
    private let checkSelectedIcon   = UIImageView()
    private let starView            = UILabel()
    private let numberStarView      = UILabel()
    private let bookNowBtn          = UIButton()
    
    private var indexPath           : Int?
    var delegate                    : SelectDoctorCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        doctorAvatar.image = UIImage(named: "default-image")
        doctorAvatar.contentMode = .scaleAspectFill
        doctorAvatar.clipsToBounds = true
        doctorAvatar.layer.cornerRadius = 8
        self.addSubview(doctorAvatar)
        doctorAvatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(110)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        doctorNameLabel.text = ""
        doctorNameLabel.numberOfLines = 0
        doctorNameLabel.font = getCustomFont(size: 13.5, name: .regular)
        doctorNameLabel.textColor = kDefaultTextColor
        doctorNameLabel.numberOfLines = 0
        self.addSubview(doctorNameLabel)
        doctorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(doctorAvatar.snp.right).offset(15)
            make.top.equalTo(doctorAvatar).offset(5)
        }
        
        heartView.image = UIImage.init(named: "heart")
        heartView.contentMode = .scaleAspectFit
        self.addSubview(heartView)
        heartView.snp.makeConstraints { make in
            make.top.equalTo(doctorNameLabel)
            make.right.equalToSuperview().offset(-17)
            make.height.width.equalTo(20)
        }
        
        addressLabel.text = "Brooklyn Hospital"
        addressLabel.numberOfLines = 0
        addressLabel.font = getCustomFont(size: 8.5, name: .semiBold)
        addressLabel.textColor = kDefaultTextColor
        addressLabel.numberOfLines = 0
        self.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(doctorNameLabel)
            make.top.equalTo(doctorNameLabel.snp.bottom).offset(4)
        }
        
        tagsContent.text = ""
        tagsContent.numberOfLines = 0
        tagsContent.font = getCustomFont(size: 9, name: .regular)
        tagsContent.textColor = kDefaultTextColor
        tagsContent.layer.cornerRadius = 2
        tagsContent.backgroundColor = UIColor.init(hexString: "ebedfb")
        self.addSubview(tagsContent)
        tagsContent.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.height.equalTo(15)
        }
        
        starView.text = "★"
        starView.font = getCustomFont(size: 10, name: .medium)
        starView.textColor = .red
        self.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.bottom.equalTo(doctorAvatar.snp.bottom).offset(-10)
            make.left.equalTo(tagsContent)
        }
        
        numberStarView.text = "4.5"
        numberStarView.font = getCustomFont(size: 11.5, name: .regular)
        numberStarView.textColor = kDefaultTextColor
        self.addSubview(numberStarView)
        numberStarView.snp.makeConstraints { make in
            make.top.equalTo(starView)
            make.left.equalTo(starView.snp.right).offset(5)
        }
        
        bookNowBtn.setTitle("Book now", for: .normal)
        bookNowBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        bookNowBtn.setTitleColor(kPrimaryColor, for: .normal)
        bookNowBtn.backgroundColor = kIceBlueColor
        bookNowBtn.layer.borderColor = kPrimaryColor.cgColor
        bookNowBtn.layer.borderWidth = 0.7
        bookNowBtn.layer.cornerRadius = 14
        bookNowBtn.addTarget(self, action: #selector(bookNowButtonTapped), for: .touchUpInside)
        self.addSubview(bookNowBtn)
        bookNowBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-17)
            make.height.equalTo(28)
            make.width.equalTo(110)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func setDataSource(_ doctorData: DoctorDataSource) {
        self.doctorNameLabel.text = (doctorData.user?.firstName ?? "") + " " + (doctorData.user?.lastName ?? "")
        
        if let avatarURL = URL(string: doctorData.user?.avatar ?? "") {
            self.doctorAvatar.setImage(url: avatarURL, placeholder: UIImage(named: "default-image")!)
        }
        
        var lastView : UIView?
        
        // Name deparment
        for teamMemberPosition in doctorData.teamMemberPosition {
            if let deparment = teamMemberPosition.team?.department {
                tagsContent.text = String(format: "  %@  ", deparment.name)
//                let newChipView = ChipView.init(title: deparment.name)
//                newChipView.backgroundColor = kRedHightLightColor
//                newChipView.borderColor = kRedHightLightColor
//                newChipView.textLabel.textColor = .white
//                newChipView.textLabel.font = getCustomFont(size: 11, name: .semiBold)
//                tagsContent.addSubview(newChipView)
//
//                if let lastView = lastView {
//                    newChipView.snp.makeConstraints { make in
//                        make.centerY.top.bottom.equalToSuperview()
//                        make.left.equalTo(lastView.snp.right).offset(10)
//                    }
//                } else {
//                    newChipView.snp.makeConstraints { make in
//                        make.centerY.top.bottom.equalToSuperview()
//                        make.left.equalToSuperview().offset(10)
//                    }
//                }
//
//                lastView = newChipView
            }
        }
        
        // Experience
//        if let expAtribute = doctorData.attributeValues.first(where: { doctorAttribute in
//            return doctorAttribute.attributeCode == .Experience
//        }) {
//            let newChipView = ChipView.init(title: expAtribute.value)
//            newChipView.backgroundColor = kPrimaryColor
//            newChipView.borderColor = kPrimaryColor
//            newChipView.textLabel.textColor = .white
//            newChipView.textLabel.font = getCustomFont(size: 11, name: .semiBold)
//            tagsContent.addSubview(newChipView)
//
//            if let lastView = lastView {
//                newChipView.snp.makeConstraints { make in
//                    make.centerY.top.bottom.equalToSuperview()
//                    make.left.equalTo(lastView.snp.right).offset(10)
//                }
//            } else {
//                newChipView.snp.makeConstraints { make in
//                    make.centerY.top.bottom.equalToSuperview()
//                    make.left.equalToSuperview().offset(10)
//                }
//            }
//
//            lastView = newChipView
//        }
//
//        lastView?.snp.makeConstraints({ make in
//            make.right.lessThanOrEqualToSuperview().offset(-10)
//        })
    }
    
    func setIsSelected(_ isSelected: Bool = false) {
        self.checkSelectedIcon.isHidden = !isSelected
    }
    
    func setIndexPath(_ index: Int) {
        self.indexPath = index
    }
    
    // MARK: - Buttons
    @objc private func bookNowButtonTapped() {
        if let indexPath = indexPath {
            delegate?.bookNow(indexPath)
        }
    }
}
