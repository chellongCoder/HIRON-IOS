//
//  ItemReview.swift
//  Heron
//
//  Created by Longnn on 21/12/2022.
//

import UIKit

class ItemReview: UIView {
    let avatar          = UIImageView()
    let rateUserName    = UILabel()
    let stars           = UILabel()
    let category        = UILabel()
    let time            = UILabel()
    let comment         = UILabel()
    let helpful         = UILabel()
    let likeBTN         = UIButton()
    let line            = UIView()
    let starsView       = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        avatar.image = UIImage.init(named: "store")
        avatar.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = 14
        self.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(5)
            make.width.height.equalTo(28)
        }
        
        rateUserName.text = "Michelle Stewart"
        rateUserName.font = getCustomFont(size: 11, name: .bold)
        self.addSubview(rateUserName)
        rateUserName.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(7.5)
            make.top.equalToSuperview().offset(0)
        }
        
        self.loadStarsView()

//        stars.text = "★★★★★"
//        stars.textColor = UIColor.init(hexString: "ff6d6e")
//        stars.font = getCustomFont(size: 11, name: .regular)
//        self.addSubview(stars)
//        stars.snp.makeConstraints { make in
//            make.left.equalTo(avatar.snp.right).offset(10)
//            make.top.equalTo(rateUserName.snp.bottom).offset(7.5)
//        }
        
        category.text = "10ml - Red"
        category.textColor = UIColor.init(hexString: "888888")
        category.font = getCustomFont(size: 11, name: .regular)
        self.addSubview(category)
        category.snp.makeConstraints { make in
            make.left.equalTo(starsView.snp.right).offset(10)
            make.top.equalTo(rateUserName.snp.bottom).offset(7.5)
        }
        
        time.text = "3 days ago"
        time.textColor = UIColor.init(hexString: "888888")
        time.font = getCustomFont(size: 11, name: .regular)
        self.addSubview(time)
        time.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.top.equalTo(rateUserName.snp.bottom).offset(7.5)
        }

        comment.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        self.addSubview(comment)
        comment.numberOfLines = 0
        comment.textColor = kDefaultTextColor
        comment.font = getCustomFont(size: 13, name: .regular)
        comment.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(time.snp.bottom).offset(15)
            make.width.equalToSuperview()
        }
        
        likeBTN.setImage(UIImage(named: "like"), for: .normal)
        likeBTN.tintColor = kDefaultTextColor
        self.addSubview(likeBTN)
        likeBTN.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(comment.snp.bottom).offset(15)
        }
        
        helpful.text = "Helpful (5)"
        self.addSubview(helpful)
        helpful.textColor = UIColor.init(hexString: "888888")
        helpful.font = getCustomFont(size: 11, name: .regular)
        helpful.snp.makeConstraints { make in
            make.left.equalTo(likeBTN.snp.right).offset(10)
            make.top.equalTo(comment.snp.bottom).offset(15)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        line.backgroundColor = kLightGrayColor
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(helpful.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    private func loadStarsView() {
        self.addSubview(starsView)
        self.starsView.snp.makeConstraints { (make) in
            make.left.equalTo(avatar.snp.right).offset(10)
            make.top.equalTo(rateUserName.snp.bottom).offset(7.5)
        }
        for subview in self.starsView.subviews {
            subview.removeFromSuperview()
        }
        var lastView                        : UIImageView?

        for i in 1...5 {
            let starImage = UIImageView()
            starImage.image = i == 5 ? UIImage.init(named: "star_empty_icon") : UIImage.init(named: "star_icon")
            starImage.contentMode = .scaleAspectFit
            self.starsView.addSubview(starImage)

            if lastView != nil {
                starImage.snp.makeConstraints { make in
                    make.left.equalTo(lastView!.snp.right).offset(3)
                    make.centerY.top.equalToSuperview()
                    make.width.height.equalTo(8)
                }
                
            } else {
                starImage.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.centerY.top.equalToSuperview()
                }

            }

            lastView = starImage

        }
        lastView?.snp.makeConstraints({ make in
            make.right.lessThanOrEqualToSuperview().offset(-10)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
