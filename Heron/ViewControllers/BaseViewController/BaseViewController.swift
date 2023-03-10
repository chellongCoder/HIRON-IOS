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
    
    let refreshControl          = UIRefreshControl()
    let disposeBag              = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.bindingData()
        }
    }
    
    func showBackBtn() {
        let backBtn = UIBarButtonItem.init(image: UIImage.init(named: "back_icon_nav"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    func showCloseBtn() {
        let closeBtn = UIBarButtonItem.init(image: UIImage.init(named: "close_bar_icon"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = closeBtn
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
        
    func bindingData() {}
    
    @objc func reloadData() {}
}

class PageScrollViewController : BaseViewController {
    internal let pageScroll     = UIScrollView()
    let contentView             = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageScroll.showsVerticalScrollIndicator = false
        self.view.addSubview(pageScroll)
        pageScroll.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        contentView.backgroundColor = .white
        pageScroll.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.width.equalToSuperview()
        }
    }
}
