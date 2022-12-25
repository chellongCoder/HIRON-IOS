//
//  TabView.swift
//  Heron
//
//  Created by Longnn on 20/11/2022.
//

import Foundation
class TabViewProductDetail: UIView {
    private let stackView           = UIView()

    private let productBtn          = UIButton()
    private let reviewBtn           = UIButton()
    private let relateBtn           = UIButton()
    private var separatorView       = UIView()
    var scrollView                  : UIScrollView?
    weak var viewController         : ProductDetailsViewController?

    private var selectedSegmentBtn  : UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
    
        stackView.addSubview(productBtn)
        productBtn.isSelected = true
        productBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        productBtn.setTitle("Product", for: .normal)
        productBtn.setTitleColor(UIColor.init(hexString: "888888"), for: .normal)
        productBtn.setTitleColor(kDefaultTextColor, for: .selected)
        productBtn.titleLabel?.font = getCustomFont(size: 11, name: .semiBold)
        productBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(46)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        self.selectedSegmentBtn = productBtn

        stackView.addSubview(reviewBtn)
        reviewBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        reviewBtn.setTitle("Review", for: .normal)
        reviewBtn.setTitleColor(UIColor.init(hexString: "888888"), for: .normal)
        reviewBtn.setTitleColor(kDefaultTextColor, for: .selected)
        reviewBtn.titleLabel?.font = getCustomFont(size: 12, name: .semiBold)
        reviewBtn.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(46)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        stackView.addSubview(relateBtn)
        relateBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        relateBtn.setTitle("Relate", for: .normal)
        relateBtn.setTitleColor(UIColor.init(hexString: "888888"), for: .normal)
        relateBtn.setTitleColor(kDefaultTextColor, for: .selected)
        relateBtn.titleLabel?.font = getCustomFont(size: 12, name: .semiBold)
        relateBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(46)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        self.addSubview(stackView)
        stackView.backgroundColor = .white
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.height.width.equalToSuperview()
        }
        
        separatorView.backgroundColor = UIColor.init(hexString: "888888")
        self.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalTo(selectedSegmentBtn!)
            make.height.equalTo(2)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func segmentBtnTapped(sender: UIButton) {
        if(sender == productBtn) {
            let bottomOffset = CGPoint(x: 0, y: 0)
            self.scrollView?.setContentOffset(bottomOffset, animated: true)
        } else if(sender == reviewBtn) {
            let bottomOffset = CGPoint(x: 0, y: self.viewController!.reviewRate.frame.minY - 40)
            self.scrollView?.setContentOffset(bottomOffset, animated: true)
        } else {
            let bottomOffset = CGPoint(x: 0, y: self.viewController!.titleReleatedProduct.frame.minY - 50)
            self.scrollView?.setContentOffset(bottomOffset, animated: true)
        }
        
        if selectedSegmentBtn == sender {
            return
        }
        
        selectedSegmentBtn?.isSelected = false
        sender.isSelected = true
        selectedSegmentBtn = sender
        
        separatorView.snp.remakeConstraints { (remake) in
            remake.bottom.centerX.width.equalTo(selectedSegmentBtn!)
            remake.height.equalTo(2)
        }
        
    }
    
}
