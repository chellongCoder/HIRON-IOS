//
//  BaseViewController.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit
import Alamofire
import RxSwift

class BaseViewController: UIViewController {
    
    internal let pageScroll     = UIScrollView()
    let contentView             = UIView()
    let disposeBage         = DisposeBag()
    let disposeBag         = DisposeBag()

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
        self.configUI()
        self.bindingData()
        self.view.layoutIfNeeded()
        
    }
    
    func configUI() {}
    
    func bindingData() {}
}
