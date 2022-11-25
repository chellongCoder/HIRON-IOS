//
//  ItemReview.swift
//  Heron
//
//  Created by Longnn on 25/11/2022.
//

import Foundation
class ItemReview: UIView {
    let view = UIView()
    let avatar      = UIImageView()
    let rateUserName    = UILabel()
    let stars    = UILabel()
    let category    = UILabel()
    let time    = UILabel()
    let comment    = UILabel()
    let helpful    = UILabel()

    let likeBTN          = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatar.image = UIImage.init(named: "store")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = 14
        view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        view.addSubview(rateUserName)
        rateUserName.text = "Michelle Stewart"
        rateUserName.font = getCustomFont(size: 11, name: .bold)
        rateUserName.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(10)
            make.top.equalToSuperview()
        }
        view.addSubview(stars)
        stars.text = "★★★★★"
        stars.textColor = UIColor.init(hexString: "ff6d6e")
        stars.font = getCustomFont(size: 11, name: .regular)
        stars.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(10)
            make.top.equalTo(rateUserName.snp.bottom).offset(15)
        }
        view.addSubview(category)
        category.text = "10ml - Red"
        category.textColor = UIColor.init(hexString: "888888")
        category.font = getCustomFont(size: 11, name: .regular)
        category.snp.makeConstraints { make in
            make.left.equalTo(stars.snp.right).offset(10)
            make.top.equalTo(rateUserName.snp.bottom).offset(15)
        }
        
        time.text = "3 days ago"
        view.addSubview(time)
        time.textColor = UIColor.init(hexString: "888888")
        time.font = getCustomFont(size: 11, name: .regular)
        time.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.top.equalTo(rateUserName.snp.bottom).offset(15)
        }

        comment.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        view.addSubview(comment)
        comment.numberOfLines = 2
        comment.textColor = kDefaultTextColor
        comment.font = getCustomFont(size: 13, name: .regular)
        comment.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(time.snp.bottom).offset(15)
            make.width.equalToSuperview()
        }
        
        likeBTN.setImage(UIImage(named: "like"), for: .normal)
        likeBTN.tintColor = kDefaultTextColor
        view.addSubview(likeBTN)
        likeBTN.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(comment.snp.bottom).offset(15)
        }
        
        helpful.text = "Helpful (5)"
        view.addSubview(helpful)
        helpful.textColor = UIColor.init(hexString: "888888")
        helpful.font = getCustomFont(size: 11, name: .regular)
        helpful.snp.makeConstraints { make in
            make.left.equalTo(likeBTN.snp.right).offset(10)
            make.top.equalTo(comment.snp.bottom).offset(15)
        }
                
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
