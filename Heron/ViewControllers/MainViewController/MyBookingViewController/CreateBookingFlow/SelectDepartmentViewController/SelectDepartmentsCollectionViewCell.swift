//
//  SelectDepartmentsTableViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

class SelectDepartmentsCollectionViewCell: UICollectionViewCell {
    
    let cellContentView             = UIView()
    private let departmentIcon      = UIImageView()
    private let departmentNameLabel = UILabel()
    private let departmentForm      = UILabel()
    private let discountValue       = DiscountValueView()
    private let priceLabel          = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellContentView.layer.cornerRadius = 8
        self.contentView.addSubview(cellContentView)
        cellContentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalToSuperview().offset(-16)
        }
        
        departmentIcon.layer.cornerRadius = 20
        departmentIcon.layer.masksToBounds = true
        departmentIcon.backgroundColor = .white
        cellContentView.addSubview(departmentIcon)
        departmentIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.height.width.equalTo(40)
        }
                
        departmentNameLabel.text = ""
        departmentNameLabel.font = getCustomFont(size: 14, name: .bold)
        departmentNameLabel.textColor = kDefaultTextColor
        cellContentView.addSubview(departmentNameLabel)
        departmentNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departmentIcon.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        departmentForm.text = ""
        departmentForm.font = getCustomFont(size: 12, name: .regular)
        departmentForm.textColor = kDefaultTextColor
        departmentForm.numberOfLines = 0
        cellContentView.addSubview(departmentForm)
        departmentForm.snp.makeConstraints { (make) in
            make.top.equalTo(departmentNameLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        priceLabel.text = "%200.00"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func setDataSource(_ departmentData: DepartmentDataSource) {
        self.departmentNameLabel.text = departmentData.name
    }
}
