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
    
    private let topLineView     = UIView()
    private let titleLabel      = UILabel()
    private let desciptionLabel = UILabel()
    private let additionalListView = UIView()
    private let dateAvailableLabel  = UILabel()
    private let selectBtn            = ExtendedButton()
    
    private var voucherData     : VoucherDataSource?
    var delegate                : VoucherTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear

        let contentView = UIView()
        contentView.backgroundColor = UIColor.init(hexString: "fafbfe")
        contentView.layer.masksToBounds = true
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(8)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            contentView.setDashlineBorder(kPurpleColor, cornerRadius: 8)
            contentView.bringSubviewToFront(self.topLineView)
        }
      
        topLineView.backgroundColor = kPurpleColor
        contentView.addSubview(topLineView)
        topLineView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.top.equalToSuperview().offset(-1)
            make.left.right.equalToSuperview()
        }
        
        titleLabel.text = ""
        titleLabel.font = getCustomFont(size: 16, name: .extraBold)
        titleLabel.textColor = kPurpleColor
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(12)
        }
        
        selectBtn.setBackgroundImage(UIImage.init(named: "select_icon"), for: .normal)
        selectBtn.backgroundColor = kPrimaryColor
        selectBtn.layer.cornerRadius = 8
        contentView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.height.width.equalTo(16)
        }
        
        desciptionLabel.text = "Discount $10.00 lorem Ipsum is simply dummy text of the printing and standard typesetting industry."
        desciptionLabel.font = getCustomFont(size: 13, name: .light)
        desciptionLabel.textColor = kDefaultTextColor
        desciptionLabel.numberOfLines = 0
        contentView.addSubview(desciptionLabel)
        desciptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        contentView.addSubview(additionalListView)
        additionalListView.snp.makeConstraints { make in
            make.top.equalTo(desciptionLabel.snp.bottom)
            make.centerX.width.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        let dateContentView = UIView()
        dateContentView.backgroundColor = UIColor.init(hexString: "fafbfe")
        dateContentView.layer.masksToBounds = true
        self.contentView.addSubview(dateContentView)
        dateContentView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.bottom)
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(37)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
        
        dateAvailableLabel.text = ""
        dateAvailableLabel.numberOfLines = 0
        dateAvailableLabel.font = getCustomFont(size: 13, name: .regular)
        dateAvailableLabel.textColor = kDefaultTextColor
        dateContentView.addSubview(dateAvailableLabel)
        dateAvailableLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().offset(-24)
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dateContentView.setDashlineBorder(kPurpleColor, cornerRadius: 8)
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
        self.desciptionLabel.text = cellData.couponRule?.description
        
        if cellData.couponRule?.isFixed ?? false {
            // discount value
//            self.promoValue.text = getMoneyFormat(cellData.couponRule?.customDiscount)
            
        } else {
            // discout percent
//            self.promoValue.text = String(format: "%ld%% OFF", cellData.couponRule?.discount ?? 0)
        }
        
        if cellData.isSelectedVoucher {
            self.selectBtn.isHidden = false
        } else {
            self.selectBtn.isHidden = true
        }
        
        #warning("HARD_CODE")
        let contents = ["Lorem Ipsum is simply dummy text.",
                        "Lorem Ipsum is simply dummy text.",
                        "Lorem Ipsum is simply dummy text.",
                        "Lorem Ipsum is simply dummy text.",
                        "Lorem Ipsum is simply dummy text.",
                        "Lorem Ipsum is simply dummy text."]
        var lastetContent : UIView?
        
        for content in contents {
            
            let chamIcon = UIView()
            chamIcon.backgroundColor = kDefaultTextColor
            self.additionalListView.addSubview(chamIcon)
            chamIcon.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(32)
                make.height.width.equalTo(5)
            }
                        
            let contentLabel = UILabel()
            contentLabel.text = content
            contentLabel.numberOfLines = 0
            contentLabel.font = getCustomFont(size: 13, name: .light)
            contentLabel.textColor = kTitleTextColor
            self.additionalListView.addSubview(contentLabel)
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(chamIcon).offset(-5)
                make.left.equalTo(chamIcon.snp.right).offset(6)
                make.right.equalToSuperview().offset(-16)
            }
            
            if let lastetContent = lastetContent {
                chamIcon.snp.makeConstraints { make in
                    make.top.equalTo(lastetContent.snp.bottom).offset(17)
                }
            } else {
                chamIcon.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(17)
                }
            }
            
            lastetContent = contentLabel
        }
        
        lastetContent?.snp.makeConstraints({ make in
            make.bottom.lessThanOrEqualToSuperview()
        })
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
