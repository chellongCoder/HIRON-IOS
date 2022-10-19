//
//  ShippingInfoTableViewCell.swift
//  Heron
//
//  Created by Triet Nguyen on 14/06/2022.
//
import RxSwift

class ShippingAndBillingInfoTableViewCell: UITableViewCell {
    
    let shippingName       = UILabel()
    let shippingAddressLabel    = UILabel()
    let billingAddressName      = UILabel()
    let billingAddressEmail     = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview()
        }
        
        let ađressInforTitle = UILabel()
        ađressInforTitle.text = "Address Information"
        ađressInforTitle.textColor = kDefaultTextColor
        ađressInforTitle.font = getFontSize(size: 16, weight: .bold)
        contentView.addSubview(ađressInforTitle)
        ađressInforTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
        
        let shippingAddressTitle = UILabel()
        shippingAddressTitle.text = "Shipping Address"
        shippingAddressTitle.font = getFontSize(size: 14, weight: .medium)
        contentView.addSubview(shippingAddressTitle)
        shippingAddressTitle.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(ađressInforTitle.snp.bottom).offset(16)
        }
        
        shippingName.text = ""
        shippingName.font = getFontSize(size: 14, weight: .regular)
        shippingAddressLabel.numberOfLines = 0
        contentView.addSubview(shippingName)
        shippingName.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(shippingAddressTitle.snp.bottom).offset(8)
        }
        
        shippingAddressLabel.text = ""
        shippingAddressLabel.font = getFontSize(size: 14, weight: .regular)
        shippingAddressLabel.numberOfLines = 0
        contentView.addSubview(shippingAddressLabel)
        shippingAddressLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(shippingName.snp.bottom)
        }
        
        let seperate_line = UIView()
        seperate_line.backgroundColor = .lightGray
        contentView.addSubview(seperate_line)
        seperate_line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(shippingAddressLabel.snp.bottom).offset(10)
        }
        
        let billingAddressLabel = UILabel()
        billingAddressLabel.text = "Billing Address"
        billingAddressLabel.font = getFontSize(size: 14, weight: .medium)
        contentView.addSubview(billingAddressLabel)
        billingAddressLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(seperate_line.snp.bottom).offset(27)
        }
        
        billingAddressName.text = ""
        billingAddressName.numberOfLines = 0
        billingAddressName.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(billingAddressName)
        billingAddressName.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(billingAddressLabel.snp.bottom).offset(8)
        }
        
        billingAddressEmail.text = ""
        billingAddressEmail.font = getFontSize(size: 14, weight: .regular)
        contentView.addSubview(billingAddressEmail)
        billingAddressEmail.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(billingAddressName.snp.bottom)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUserData(_ userData: OrderUserMetadata?) {
        self.billingAddressName.text = String(format: "%@ %@ | %@%@",
                                              userData?.firstName ?? "",
                                              userData?.lastName ?? "",
                                              userData?.phoneCountryCode ?? "",
                                              userData?.phoneNumber ?? "")
        self.billingAddressEmail.text = userData?.email ?? ""
    }
    
    func setShippingData(_ shippingData: OrderShippingData?) {
        self.shippingName.text = String(format: "%@ %@ | %@",
                                        shippingData?.recipient?.firstName ?? "",
                                        shippingData?.recipient?.lastName ?? "",
                                        shippingData?.recipient?.phone ?? "")
        self.shippingAddressLabel.text = shippingData?.recipient?.getAddressString()
    }
}
