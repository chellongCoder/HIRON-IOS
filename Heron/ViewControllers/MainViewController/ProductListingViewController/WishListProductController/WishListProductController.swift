//
//  WishListProductController.swift
//  Heron
//
//  Created by Longnn on 28/01/2023.
//

import Foundation
class WishListProductController: BaseViewController,
                                 UITableViewDelegate, EmptyViewDelegate {
    func didSelectEmptyButton() {
        
    }
    
    let emptyView               = EmptyView()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.showBackBtn()
        self.navigationItem.title = "Wishlist"
        
        emptyView.imageView.snp.remakeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emptyView.snp.centerY)
            make.width.equalTo(110)
            make.height.equalTo(157)
        })
        emptyView.titleLabel.text = "Your Wishlist is Empty"
        emptyView.titleLabel.font = getCustomFont(size: 18, name: .bold)
        emptyView.messageLabel.text = "Tap heart button to start saving your favorite items."
        emptyView.actionButon.setTitle("Add Now", for: .normal)
        emptyView.actionButon.titleLabel?.font = getCustomFont(size: 14.5, name: .bold)
        emptyView.actionButon.layer.cornerRadius = 18
        emptyView.actionButon.snp.makeConstraints {
            $0.top.equalTo(emptyView.messageLabel.snp.bottom).offset(36)
            $0.width.equalToSuperview().offset(-235)
            $0.height.equalTo(36)
            $0.centerX.equalToSuperview()
        }
        emptyView.delegate = self
//        emptyView.isHidden = true
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
