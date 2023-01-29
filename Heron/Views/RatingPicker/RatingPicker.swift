//
//  RatingPicker.swift
//  Heron
//
//  Created by Longnn on 25/01/2023.
//

import Foundation
class RatingPicker: UIView {
    
    @objc func onClick(sender: RatingButton) {
        print(sender.tag)
        sender.isSelected = !sender.isSelected
    }
    
    init() {
        super.init(frame: .zero)
        let label = UILabel(frame: .zero)
        label.text = "Rating"
        label.font = getCustomFont(size: 14.5, name: .bold)
        label.textColor = kDefaultTextColor
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        var lastView                        : UIView?

        for (index, range) in [5, 4, 3, 2, 1].enumerated() {
            let rateBtn = RatingButton(String(range))
            rateBtn.tag = range
            rateBtn.addTarget(self, action: #selector(onClick), for: .touchUpInside)

            self.addSubview(rateBtn)
            if lastView != nil {
                rateBtn.snp.makeConstraints { make in
                    make.left.equalTo(lastView!.snp.right).offset(12)
                    make.top.equalTo(label.snp.bottom).offset(16)
                    make.width.equalTo(59)
                    make.height.equalTo(37)
                }
            } else {
                rateBtn.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.top.equalTo(label.snp.bottom).offset(16)
                    make.width.equalTo(59)
                    make.height.equalTo(37)

                }
            }
            
            lastView = rateBtn

        }
        
        lastView?.snp.makeConstraints({ make in
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        })

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
