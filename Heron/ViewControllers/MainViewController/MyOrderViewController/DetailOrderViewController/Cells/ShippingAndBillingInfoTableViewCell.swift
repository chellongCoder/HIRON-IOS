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
        
        let locationImage1 = UIImageView()
        locationImage1.image = UIImage.init(named: "location_icon")
        locationImage1.layer.masksToBounds = true
        locationImage1.contentMode = .scaleAspectFit
        contentView.addSubview(locationImage1)
        locationImage1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(20)
        }
        
        let ađressInforTitle = UILabel()
        ađressInforTitle.text = "Shipping Information"
        ađressInforTitle.textColor = kTitleTextColor
        ađressInforTitle.font = getCustomFont(size: 13, name: .bold)
        contentView.addSubview(ađressInforTitle)
        ađressInforTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(locationImage1.snp.right).offset(12)
        }
        
        shippingName.text = ""
        shippingName.font = getCustomFont(size: 13, name: .medium)
        shippingName.textColor = kTitleTextColor
        shippingAddressLabel.numberOfLines = 0
        contentView.addSubview(shippingName)
        shippingName.snp.makeConstraints {
            $0.left.equalTo(ađressInforTitle)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ađressInforTitle.snp.bottom).offset(12)
        }
        
        shippingAddressLabel.text = ""
        shippingAddressLabel.font = getCustomFont(size: 13, name: .regular)
        shippingAddressLabel.textColor = kTitleTextColor
        shippingAddressLabel.numberOfLines = 0
        contentView.addSubview(shippingAddressLabel)
        shippingAddressLabel.snp.makeConstraints {
            $0.left.equalTo(ađressInforTitle)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(shippingName.snp.bottom).offset(12)
        }
        
        let seperate_line = UIView()
        seperate_line.backgroundColor = kGrayColor
        contentView.addSubview(seperate_line)
        seperate_line.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(shippingAddressLabel.snp.bottom).offset(20)
        }
        
        locationImage1.snp.makeConstraints { make in
            make.bottom.equalTo(seperate_line)
        }
        
        let locationImage2 = UIImageView()
        locationImage2.image = UIImage.init(named: "location_icon")
        locationImage2.layer.masksToBounds = true
        locationImage2.contentMode = .scaleAspectFit
        contentView.addSubview(locationImage2)
        locationImage2.snp.makeConstraints { make in
            make.top.equalTo(seperate_line.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(20)
            make.bottom.equalToSuperview()
        }
        
        let billingAddressLabel = UILabel()
        billingAddressLabel.text = "Billing Address"
        billingAddressLabel.font = getCustomFont(size: 13, name: .bold)
        billingAddressLabel.textColor = kTitleTextColor
        contentView.addSubview(billingAddressLabel)
        billingAddressLabel.snp.makeConstraints {
            $0.left.equalTo(ađressInforTitle)
            $0.top.equalTo(seperate_line.snp.bottom).offset(20)
        }
        
        billingAddressName.text = "300 Park Ave, New York, NY 10022"
        billingAddressName.numberOfLines = 0
        billingAddressName.font = getCustomFont(size: 13, name: .medium)
        contentView.addSubview(billingAddressName)
        billingAddressName.snp.makeConstraints {
            $0.left.equalTo(billingAddressLabel)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(billingAddressLabel.snp.bottom).offset(12)
        }
        
        billingAddressEmail.text = "300 Park Ave, New York, NY 10022"
        billingAddressEmail.font = getCustomFont(size: 13, name: .regular)
        contentView.addSubview(billingAddressEmail)
        billingAddressEmail.snp.makeConstraints {
            $0.left.left.equalTo(billingAddressLabel)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(billingAddressName.snp.bottom).offset(12)
            $0.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUserData(_ userData: OrderUserMetadata?) {
//        self.billingAddressName.text = String(format: "%@ %@ | %@%@",
//                                              userData?.firstName ?? "",
//                                              userData?.lastName ?? "",
//                                              userData?.phoneCountryCode ?? "",
//                                              userData?.phoneNumber ?? "")
//        self.billingAddressEmail.text = userData?.email ?? ""
    }
    
    func setShippingData(_ shippingData: OrderShippingData?) {
        self.shippingName.text = String(format: "%@ %@ | %@",
                                        shippingData?.recipient?.firstName ?? "",
                                        shippingData?.recipient?.lastName ?? "",
                                        shippingData?.recipient?.phone ?? "")
        self.shippingAddressLabel.text = shippingData?.recipient?.getAddressString()
    }
}
