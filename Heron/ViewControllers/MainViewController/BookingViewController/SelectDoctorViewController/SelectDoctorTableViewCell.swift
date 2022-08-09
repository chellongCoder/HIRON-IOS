//
//  SelectDoctorTableViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

protocol SelectDoctorCellDelegate {
    func bookNow(_ indexPath: Int)
}

class SelectDoctorTableViewCell: UITableViewCell {
    
    private let doctorAvatar        = UIImageView()
    private let doctorNameLabel     = UILabel()
    private let tagsContent         = UIView()
    private let checkSelectedIcon   = UIImageView()
    private let starView            = UILabel()
    private let bookNowBtn          = UIButton()
    
    private var indexPath           : Int?
    var delegate                    : SelectDoctorCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        doctorAvatar.image = UIImage(named: "default-image")
        doctorAvatar.contentMode = .scaleAspectFill
        doctorAvatar.clipsToBounds = true
        doctorAvatar.layer.cornerRadius = 8
        contentView.addSubview(doctorAvatar)
        doctorAvatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(120)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        doctorNameLabel.text = ""
        doctorNameLabel.numberOfLines = 0
        doctorNameLabel.font = getFontSize(size: 16, weight: .medium)
        doctorNameLabel.textColor = kDefaultTextColor
        doctorNameLabel.numberOfLines = 0
        contentView.addSubview(doctorNameLabel)
        doctorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(doctorAvatar.snp.right).offset(15)
            make.top.equalTo(doctorAvatar)
            make.right.equalToSuperview().offset(-16)
        }
        
//        tagsContent.text = ""
//        tagsContent.numberOfLines = 0
//        tagsContent.font = getFontSize(size: 12, weight: .regular)
//        tagsContent.textColor = kDefaultTextColor
        contentView.addSubview(tagsContent)
        tagsContent.snp.makeConstraints { (make) in
            make.left.equalTo(doctorAvatar.snp.right).offset(15)
            make.top.equalTo(doctorNameLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }
        
        starView.text = "★★★★★"
        starView.font = getFontSize(size: 16, weight: .medium)
        starView.textColor = UIColor.init(hexString: "F1C644")
        contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalTo(tagsContent.snp.bottom).offset(5)
            make.left.equalTo(tagsContent)
        }
        
        bookNowBtn.setTitle("Book Now", for: .normal)
        bookNowBtn.backgroundColor = kPrimaryColor
        bookNowBtn.layer.cornerRadius = 8
        bookNowBtn.addTarget(self, action: #selector(bookNowButtonTapped), for: .touchUpInside)
        contentView.addSubview(bookNowBtn)
        bookNowBtn.snp.makeConstraints { make in
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.left.equalTo(doctorNameLabel)
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
                let newChipView = ChipView.init(title: deparment.name)
                newChipView.backgroundColor = kRedHightLightColor
                newChipView.borderColor = kRedHightLightColor
                newChipView.textLabel.textColor = .white
                tagsContent.addSubview(newChipView)
                
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
            tagsContent.addSubview(newChipView)
            
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
