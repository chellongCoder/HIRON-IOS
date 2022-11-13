//
//  VoucherTableViewCell.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit

protocol VoucherTableViewCellDelegate : AnyObject {
    func didApplyVoucher(_ voucher: VoucherDataSource)
    func didCancelVoucher()
}

class VoucherTableViewCell: UITableViewCell {
    
    private let promoValue      = UILabel()
    private let titleLabel      = UILabel()
    private let dateAvailableLabel  = UILabel()
    private let applyBtn        = UIButton()
    
    private var voucherData     : VoucherDataSource?
    var delegate                : VoucherTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.setShadow()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        promoValue.text = "0% OFF"
        promoValue.textAlignment = .center
        promoValue.textColor = kDefaultTextColor
        promoValue.backgroundColor = kBackgroundColor
        promoValue.font = getCustomFont(size: 14, name: .medium)
        contentView.addSubview(promoValue)
        promoValue.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.width.equalTo(100)
        }
        
        titleLabel.text = ""
        titleLabel.font = getCustomFont(size: 14, name: .medium)
        titleLabel.textColor = kDefaultTextColor
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(promoValue.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        dateAvailableLabel.text = ""
        dateAvailableLabel.numberOfLines = 0
        dateAvailableLabel.font = getCustomFont(size: 14, name: .regular)
        dateAvailableLabel.textColor = kDefaultTextColor
        contentView.addSubview(dateAvailableLabel)
        dateAvailableLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(promoValue.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        applyBtn.setTitle("Apply", for: .normal)
        applyBtn.backgroundColor = kPrimaryColor
        applyBtn.layer.cornerRadius = 8
        applyBtn.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        contentView.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(dateAvailableLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.left.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func setDataSource(_ cellData: VoucherDataSource) {
        self.voucherData = cellData
        
        self.titleLabel.text = cellData.couponRule?.title ?? ""
        self.dateAvailableLabel.text = TimeConverter().getDateFromInt(cellData.couponRule?.startTime ?? 0) + " - " + TimeConverter().getDateFromInt(cellData.couponRule?.endTime ?? 0)
        
        if cellData.couponRule?.isFixed ?? false {
            // discount value
            self.promoValue.text = getMoneyFormat(cellData.couponRule?.customDiscount)
            
        } else {
            // discout percent
            self.promoValue.text = String(format: "%ld%% OFF", cellData.couponRule?.discount ?? 0)
        }
        
        if cellData.isSelectedVoucher {
            self.applyBtn.setTitle("Cancel", for: .normal)
            self.applyBtn.backgroundColor = kRedHightLightColor
        } else {
            self.applyBtn.setTitle("Apply", for: .normal)
            self.applyBtn.backgroundColor = kPrimaryColor
        }
    }
    
    // MARK: - Buttons
    @objc private func applyButtonTapped() {
        guard let voucherData = voucherData else {
            return
        }

        if voucherData.isSelectedVoucher {
            self.delegate?.didCancelVoucher()
        } else {
            self.delegate?.didApplyVoucher(voucherData)
        }
    }
}
