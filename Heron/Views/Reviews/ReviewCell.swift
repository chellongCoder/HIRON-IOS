//
//  ReviewCell.swift
//  Heron
//
//  Created by Lucas on 1/5/23.
//

import UIKit

class ReviewCell: UIView {
    
    let avatarImage             = UIImageView()
    let nameTitle               = UILabel()
    let starImage               = UILabel()
    let dayTitle                = UILabel()
    let reviewContentTitle      = UILabel()
    let likeImage               = UIButton()
    let helpfulTitle            = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
               
        avatarImage.image = UIImage.init(named: "avatar_default")
        self.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(28)
        }
        
        nameTitle.text = "Michelle Stewart"
        nameTitle.font = getCustomFont(size: 11.5, name: .bold)
        nameTitle.textColor = kTitleTextColor
        self.addSubview(nameTitle)
        nameTitle.snp.makeConstraints { make in
            make.top.equalTo(avatarImage)
            make.left.equalTo(avatarImage.snp.right).offset(8)
        }
        
        starImage.text = "★★★★★"
        starImage.font = getCustomFont(size: 11, name: .medium)
        starImage.textColor = .red
        self.addSubview(starImage)
        starImage.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(8.5)
            make.left.equalTo(nameTitle)
        }
        
        dayTitle.text = "3 days ago"
        dayTitle.font = getCustomFont(size: 11.5, name: .regular)
        dayTitle.textColor = kCustomTextColor
        self.addSubview(dayTitle)
        dayTitle.snp.makeConstraints { make in
            make.top.equalTo(starImage)
            make.right.equalToSuperview().offset(-16)
        }
        
        reviewContentTitle.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        reviewContentTitle.font = getCustomFont(size: 13.5, name: .light)
        reviewContentTitle.numberOfLines = 0
        reviewContentTitle.textColor = kDefaultTextColor
        self.addSubview(reviewContentTitle)
        reviewContentTitle.snp.makeConstraints { make in
            make.top.equalTo(starImage.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        likeImage.setImage(UIImage.init(named: "like"), for: .normal)
        likeImage.addTarget(self, action: #selector(likeButton), for: .touchUpInside)
        self.addSubview(likeImage)
        likeImage.snp.makeConstraints { make in
            make.top.equalTo(reviewContentTitle.snp.bottom).offset(16.5)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(14)
        }
        
        helpfulTitle.text = "Helpful (5)"
        helpfulTitle.font = getCustomFont(size: 11.5, name: .regular)
        helpfulTitle.textColor = kCustomTextColor
        self.addSubview(helpfulTitle)
        helpfulTitle.snp.makeConstraints { make in
            make.top.equalTo(likeImage)
            make.left.equalTo(likeImage.snp.right).offset(5)
        }
        
        let line1 = UIView()
        line1.backgroundColor = kDefaultGreyColor
        self.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.top.equalTo(helpfulTitle.snp.bottom).offset(16)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(_ data: ReviewDataSource) {
        #warning("HARD_CODE")
        self.nameTitle.text = data.userName
    }
    
    @objc private func likeButton() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature is not available at the moment.",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                             style: .default,
                                             handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
}
