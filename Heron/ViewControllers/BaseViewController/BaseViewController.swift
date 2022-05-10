//
//  BaseViewController.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let pageScroll      = UIScrollView()
    let contentView             = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(pageScroll)
        pageScroll.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        contentView.backgroundColor = .white
        pageScroll.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.width.equalToSuperview()
        }
        
        self.view.layoutIfNeeded()
    }
}
