//
//  SelectDepartmentsTableViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

class SelectDepartmentsTableViewCell: UITableViewCell {
    
    private let departmentNameLabel = UILabel()
    private let checkSelectedIcon   = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        checkSelectedIcon.image = UIImage.init(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        checkSelectedIcon.tintColor = kPrimaryColor
        contentView.addSubview(checkSelectedIcon)
        checkSelectedIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.width.equalTo(20)
        }
        
        departmentNameLabel.text = ""
        departmentNameLabel.font = getFontSize(size: 14, weight: .medium)
        departmentNameLabel.textColor = kDefaultTextColor
        contentView.addSubview(departmentNameLabel)
        departmentNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(checkSelectedIcon.snp.left).offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func setDataSource(_ departmentData: DepartmentDataSource) {
        self.departmentNameLabel.text = departmentData.name
    }
    
    func setIsSelected(_ isSelected: Bool = false) {
        self.checkSelectedIcon.isHidden = !isSelected
    }
}