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
    
    private let packageImage        = UIImageView()
    private let doctorNameLabel     = UILabel()
    private let tagsContent         = UILabel()
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
        
        packageImage.image = UIImage(named: "default-image")
        packageImage.contentMode = .scaleAspectFill
        packageImage.clipsToBounds = true
        packageImage.layer.cornerRadius = 8
        contentView.addSubview(packageImage)
        packageImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(120)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        doctorNameLabel.text = ""
        doctorNameLabel.numberOfLines = 0
        doctorNameLabel.font = getFontSize(size: 16, weight: .medium)
        tagsContent.textColor = kDefaultTextColor
        doctorNameLabel.numberOfLines = 0
        contentView.addSubview(doctorNameLabel)
        doctorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(packageImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        tagsContent.text = ""
        tagsContent.numberOfLines = 0
        tagsContent.font = getFontSize(size: 12, weight: .regular)
        tagsContent.textColor = kDefaultTextColor
        contentView.addSubview(tagsContent)
        tagsContent.snp.makeConstraints { (make) in
            make.left.equalTo(packageImage.snp.right).offset(15)
            make.top.equalTo(doctorNameLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-16)
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
        var tagSting = ""
        for attrubute in doctorData.attributeValues {
            tagSting = tagSting + ", " + (attrubute.attribute?.label ?? "")
        }
        self.tagsContent.text = tagSting
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
