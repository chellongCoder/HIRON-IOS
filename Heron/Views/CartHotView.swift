//
//  CartHotView.swift
//  Heron
//
//  Created by Luu Luc on 01/06/2022.
//

import UIKit
import RxSwift

class CartHotView: UIView {
    
    let cartPriceValue      = UILabel()
    private let disposeBag  = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
                
        let cartIcon = UIImageView(image: UIImage.init(systemName: "cart")?.withRenderingMode(.alwaysTemplate))
        cartIcon.tintColor = .white
        self.addSubview(cartIcon)
        cartIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
            make.left.equalToSuperview().offset(15)
        }
        
        cartPriceValue.textColor = .white
        cartPriceValue.text = "$27.32"
        self.addSubview(cartPriceValue)
        cartPriceValue.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalTo(cartIcon.snp.right).offset(10)
        }
        
        let rightIcon = UIImageView(image: UIImage(systemName: "chevron.right"))
        rightIcon.tintColor = .white
        self.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(15)
            make.left.equalTo(cartPriceValue.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.color = .white
        loadingIndicator.startAnimating()
        self.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.size.equalTo(rightIcon)
        }
        
        _CartServices.cartLoadingAnimation
            .observe(on: MainScheduler.instance)
            .subscribe { loadingAnimation in
                if loadingAnimation.element ?? false {
                    UIView.animate(withDuration: 1.0) {
                        rightIcon.alpha = 0.0
                    } completion: { _ in
                        loadingIndicator.alpha = 1.0
                    }
                } else {
                    UIView.animate(withDuration: 0.1) {
                        loadingIndicator.alpha = 0.0
                    } completion: { _ in
                        rightIcon.alpha = 1.0
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
