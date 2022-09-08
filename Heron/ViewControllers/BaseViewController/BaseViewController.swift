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
    internal let pageScroll     = UIScrollView()
    let contentView             = UIView()
    let disposeBag              = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        
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
        self.configUI()
        self.bindingData()
        self.view.layoutIfNeeded()
        
    }
    
    func showBackBtn() {
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    func showCloseBtn() {
        let closeBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "xmark"),
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
    
    func configUI() {}
    
    func bindingData() {}
    
    @objc func reloadData() {}
}
