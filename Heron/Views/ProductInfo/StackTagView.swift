//
//  StackTagView.swift
//  Heron
//
//  Created by Longnn on 11/11/2022.
//

import UIKit

class StackTagView: UIView {

    let stack     = ScrollableStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
    
        stack.distribution  = .fillProportionally
        stack.spacing = 4

        let tagView1 = TagView.init(title: "Physical Product")
        let tagView2 = TagView.init(title: "Bottle")
        let tagView3 = TagView.init(title: "Bottle2")
        stack.add(view: tagView1)
        stack.add(view: tagView2)
        stack.add(view: tagView3)
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(0)
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }
    
    func addArrangedSubview(_ tag: TagView) {
        stack.add(view: tag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
