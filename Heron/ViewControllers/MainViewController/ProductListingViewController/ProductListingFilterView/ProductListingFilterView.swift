//
//  ProductListingFilterView.swift
//  Heron
//
//  Created by Lucas on 11/30/22.
//

import Foundation
import UIKit

class ProductListingFilterView : UIView {
    
    let classyFilterLabel   = LeftRightImageLabel.init(rightImage: UIImage.init(named: "down_icon"))
    let exampleLabel        = LeftRightImageLabel.init(rightImage: UIImage.init(named: "down_icon"))
    let exampleLabel2       = LeftRightImageLabel.init(rightImage: UIImage.init(named: "down_icon"))
    let filterLabel         = LeftRightImageLabel.init(rightImage: UIImage.init(named: "filter_icon"))
    
    let chipView1           = ChipView(title: "New")
    let chipView2           = ChipView(title: "Lorem Ipsum")
    let chipView3           = ChipView(title: "Lorem")
    let chipView4           = ChipView(title: "Lorem Ipsum")
    
    @objc func onFilter(sender : UITapGestureRecognizer) {
        // Do what you want
        let filterViewController = FilterProdcutViewController.init()
        _NavController.pushViewController(filterViewController, animated: true)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        classyFilterLabel.textLabel?.text = "Classify"
        classyFilterLabel.textLabel?.font = getCustomFont(size: 13, name: .bold)
        self.addSubview(classyFilterLabel)
        classyFilterLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(13)
            make.left.equalToSuperview().offset(16)
        }
        
        exampleLabel.textLabel?.text = "Lorem Ipsum"
        exampleLabel.textLabel?.font = getCustomFont(size: 13, name: .medium)
        self.addSubview(exampleLabel)
        exampleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(classyFilterLabel)
            make.height.equalTo(13)
            make.left.equalTo(classyFilterLabel.snp.right).offset(12)
        }
        
        exampleLabel2.textLabel?.text = "Lorem Ipsum"
        exampleLabel2.textLabel?.font = getCustomFont(size: 13, name: .medium)
        self.addSubview(exampleLabel2)
        exampleLabel2.snp.makeConstraints { make in
            make.centerY.equalTo(classyFilterLabel)
            make.height.equalTo(13)
            make.left.equalTo(exampleLabel.snp.right).offset(12)
        }
        
        filterLabel.textLabel?.text = "Filter"
        filterLabel.textLabel?.font = getCustomFont(size: 13, name: .medium)
        self.addSubview(filterLabel)
        filterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(classyFilterLabel)
            make.height.equalTo(13)
            make.left.equalTo(exampleLabel2.snp.right).offset(12)
        }
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onFilter))
        self.filterLabel.addGestureRecognizer(gesture)

        let spacer = UIView()
        spacer.backgroundColor = kDisableColor
        self.addSubview(spacer)
        spacer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(classyFilterLabel.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }

        chipView1.textLabel.font = getCustomFont(size: 11, name: .medium)
        self.addSubview(chipView1)
        chipView1.snp.makeConstraints { make in
            make.top.equalTo(spacer.snp.bottom).offset(14)
            make.height.equalTo(18)
            make.left.equalToSuperview().offset(16)
        }
        
        chipView2.textLabel.font = getCustomFont(size: 11, name: .medium)
        self.addSubview(chipView2)
        chipView2.snp.makeConstraints { make in
            make.top.equalTo(spacer.snp.bottom).offset(14)
            make.height.equalTo(18)
            make.left.equalTo(chipView1.snp.right).offset(12)
        }
        
        chipView3.textLabel.font = getCustomFont(size: 11, name: .medium)
        self.addSubview(chipView3)
        chipView3.snp.makeConstraints { make in
            make.top.equalTo(spacer.snp.bottom).offset(14)
            make.height.equalTo(18)
            make.left.equalTo(chipView2.snp.right).offset(12)
        }
        
        chipView4.textLabel.font = getCustomFont(size: 11, name: .medium)
        self.addSubview(chipView4)
        chipView4.snp.makeConstraints { make in
            make.top.equalTo(spacer.snp.bottom).offset(14)
            make.height.equalTo(18)
            make.left.equalTo(chipView3.snp.right).offset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
