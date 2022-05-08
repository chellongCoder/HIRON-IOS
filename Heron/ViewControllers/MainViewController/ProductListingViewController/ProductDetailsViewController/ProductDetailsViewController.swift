//
//  ProductDetailsViewController.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit

class ProductDetailsViewController: BaseViewController {
    
    private let viewModel       = ProductDetailsViewModel()
    private let topMediaView    = UIScrollView()

    init(_ data: ProductDataSource) {
        super.init(nibName: nil, bundle: nil)
        viewModel.productDataSource = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Details"
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let cartButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "cart"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(cartButtonTapped))
        self.navigationItem.rightBarButtonItem = cartButtonItem
        
        let staticHeight = (UIScreen.main.bounds.size.width)*0.5625
        topMediaView.isPagingEnabled = true
        topMediaView.showsHorizontalScrollIndicator = false
        self.view.addSubview(topMediaView)
        topMediaView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(topMediaView.snp.top).offset(staticHeight + 50)
        }
        self.loadMediaView(staticHeight)
    }
    
    //MARK: - Buttons
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func cartButtonTapped() {
        
    }
    
    //MARK: - Data
    private func loadMediaView(_ height: CGFloat) {
        guard let listMedia = viewModel.productDataSource?.media else {return}
        
        for subView in topMediaView.subviews {
            subView.removeFromSuperview()
        }
        
        let width = UIScreen.main.bounds.size.width
        let size = CGSize(width: width, height: height)
        var index = 0
        
        for mediaData in listMedia {
            
            let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
            
            let cell = BannerView.init(frame: frame)
            if let imageURL = URL.init(string: mediaData.value ?? "") {
                cell.bannerImage.setImage(url: imageURL, placeholder: UIImage(named: "default-image")!)
            }
            topMediaView.addSubview(cell)
            
            index += 1
        }
//        self.pageControl.numberOfPages = viewModel.listBanners.count
        topMediaView.contentSize = CGSize.init(width: CGFloat(listMedia.count)*(size.width), height: size.height)
    }
}
