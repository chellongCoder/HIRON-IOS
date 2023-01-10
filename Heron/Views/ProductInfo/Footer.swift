//
//  Footer.swift
//  Heron
//
//  Created by Longnn on 16/11/2022.
//

import Foundation
import RxSwift
extension UIView {
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}
class ProductDetailFooter: UIView {
    private let cardAction      = UIView()
    let btnBuyNow               = UIButton()
    let btnAddtoCard            = UIButton()
    var count                   = UILabel()
    let remove                  = UIButton()
    let add                     = UIButton()
    var disposeBag              : DisposeBag?
    weak var viewModel          : ProductDetailsViewModel?
    weak var controller         : ProductDetailsViewController?
    var quantityValue           = 1

    @objc private func buyNowButtonTapped() {
        let productImage = self.controller?.productImage
        let buynowPosition : CGPoint =  btnBuyNow.convert(btnBuyNow.bounds.origin, to: self)
        let cartButtonPosition : CGPoint =  self.controller!.cartButton.convert(self.controller!.cartButton.bounds.origin, to: self)

        productImage?.frame = CGRect(x: buynowPosition.x, y: buynowPosition.y, width: 100, height: 100)
        UIView.animate(withDuration: 1.0,
                       animations: {
            productImage?.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                
                productImage?.animationZoom(scaleX: 0.2, y: 0.2)
                productImage?.animationRoted(angle: CGFloat(Double.pi))
                productImage?.frame.origin.x = cartButtonPosition.x
                productImage?.frame.origin.y = cartButtonPosition.y
                
            }, completion: { _ in
                productImage?.removeFromSuperview()
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.controller?.cartButton.animationZoom(scaleX: 2.4, y: 2.4)
                }, completion: {_ in
                    UIView.animate(withDuration: 1.0, animations: {
                        self.controller?.cartButton.animationZoom(scaleX: 1.0, y: 1.0)
                    })
                })

            })
        })

       if let simpleProductData = self.controller?.simpleProductData {
           simpleProductData.quantity = self.quantityValue

           let cartVC = CartViewController.sharedInstance
           cartVC.addProductToCart(simpleProductData)
           self.controller?.dismiss(animated: true, completion: nil)

           return
       }
        
       if let productData = self.viewModel?.productDataSource.value {
           productData.quantity = self.quantityValue

           let cartVC = CartViewController.sharedInstance
           cartVC.addProductToCart(productData)
           self.controller?.dismiss(animated: true, completion: nil)

           return
       }
    }
        
    @objc private func minusButtonTapped() {
        if self.quantityValue <= 1 {return}
        self.quantityValue -= 1
        count.text = String(format: "%ld", self.quantityValue)
    }
    
    @objc private func plusButtonTapped() {
        if self.quantityValue >= 99 {return}
        self.quantityValue += 1
        count.text = String(format: "%ld", self.quantityValue)
    }
    
    init(frame: CGRect, _ disposeBag: DisposeBag) {
        super.init(frame: frame)
        self.disposeBag = disposeBag
        remove.setTitle("+", for: .normal)
        remove.setTitleColor(kDefaultTextColor, for: .normal)
        remove.titleLabel?.font = getCustomFont(size: 13, name: .regular)
        remove.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        count.text = String(format: "%ld", self.quantityValue)
        count.textColor = kDefaultTextColor
        count.font = getCustomFont(size: 13, name: .regular)
        
        add.setTitle("-", for: .normal)
        add.setTitleColor(kDefaultTextColor, for: .normal)
        add.titleLabel?.font = getCustomFont(size: 13, name: .regular)
        add.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)

        cardAction.addSubview(add)
        cardAction.addSubview(count)
        cardAction.addSubview(remove)
        add.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        let lineView1 = UIView()
        lineView1.backgroundColor = kDefaultGreyColor
        add.addSubview(lineView1)
        lineView1.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(add.snp.right).offset(0)
            make.height.equalTo(30)
            make.width.equalTo(1)
        }
        
        count.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        remove.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        let lineView2 = UIView()
        lineView2.backgroundColor = kDefaultGreyColor
        remove.addSubview(lineView2)
        lineView2.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(remove.snp.left).offset(0)
            make.height.equalTo(30)
            make.width.equalTo(1)
        }
        
        self.addSubview(cardAction)
        cardAction.layer.borderWidth = 0.7
        cardAction.layer.cornerRadius = 6
        cardAction.layer.borderColor = kDefaultGreyColor.cgColor
        cardAction.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(106)
            make.height.equalTo(30)
        }
        
        self.addSubview(btnAddtoCard)
        btnAddtoCard.layer.cornerRadius = 20
        btnAddtoCard.titleLabel?.font = getCustomFont(size: 14, name: .regular)
        btnAddtoCard.setTitle("Add to cart", for: .normal)
        btnBuyNow.setTitleColor(.white, for: .normal)
        btnAddtoCard.backgroundColor = kDefaultGreenColor
        btnAddtoCard.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(106)
            make.height.equalTo(40)
        }
        btnAddtoCard.addTarget(self, action: #selector(buyNowButtonTapped), for: .touchUpInside)
        
        self.addSubview(btnBuyNow)
        btnBuyNow.layer.borderWidth = 0.7
        btnBuyNow.layer.cornerRadius = 20
        btnBuyNow.titleLabel?.font = getCustomFont(size: 14, name: .regular)
        btnBuyNow.setTitle("Buy now", for: .normal)
        btnBuyNow.setTitleColor(kDefaultGreenColor, for: .normal)
        btnBuyNow.backgroundColor = UIColor.init(hexString: "eefbfb")
        btnBuyNow.layer.borderColor = kDefaultGreenColor.cgColor
        btnBuyNow.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(btnAddtoCard.snp.left).offset(-10)
            make.width.equalTo(106)
            make.height.equalTo(40)
        }
        
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.color = .black
        loadingIndicator.startAnimating()
        cardAction.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        _CartServices.cartLoadingAnimation
            .observe(on: MainScheduler.instance)
            .subscribe { loadingAnimation in
                if loadingAnimation.element ?? false {
                    UIView.animate(withDuration: 1.0) {
                        self.count.alpha = 0.0
                    } completion: { _ in
                        loadingIndicator.alpha = 1.0
                    }
                } else {
                    UIView.animate(withDuration: 0.1) {
                        loadingIndicator.alpha = 0.0
                    } completion: { _ in
                        self.count.alpha = 1.0
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
