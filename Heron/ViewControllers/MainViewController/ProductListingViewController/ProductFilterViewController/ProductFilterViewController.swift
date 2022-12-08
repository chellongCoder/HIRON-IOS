//
//  ProductFilterViewController.swift
//  Heron
//
//  Created by Luu Luc on 10/05/2022.
//

import UIKit
import RxSwift

protocol ProductFilterDelegate: AnyObject {
    func didApplyFilter(_ data: CategoryDataSource?)
}

class ProductFilterViewController: BaseViewController,
                                   UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let viewModel   = ProductFilterViewModel()
    var collectionview      : UICollectionView!
    var selectedIndex       : IndexPath?
    var delegate            : ProductFilterDelegate?
    
    let cartHotInfo                 = CartHotView()    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Categories"
        self.viewModel.controller = self
        self.showBackBtn()
        
        let applyBtn = UIBarButtonItem.init(title: "Apply",
                                            style: .plain,
                                            target: self,
                                            action: #selector(applyButtonTapped))
        self.navigationItem.rightBarButtonItem = applyBtn
        
        let viewWidth = UIScreen.main.bounds.size.width/3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        self.view.addSubview(collectionview)
        collectionview.snp.makeConstraints { make in
            make.top.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-90)
        }
        
        let touchAction = UITapGestureRecognizer.init(target: self, action: #selector(cartButtonTapped))
        
        cartHotInfo.backgroundColor = kPrimaryColor
        cartHotInfo.addGestureRecognizer(touchAction)
        self.view.addSubview(cartHotInfo)
        cartHotInfo.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        viewModel.getListCategoris()
    }
    
    // MARK: - Buttons
    override func backButtonTapped() {
        delegate?.didApplyFilter(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func applyButtonTapped() {
        if let selectedIndex = selectedIndex {
            delegate?.didApplyFilter(viewModel.listCategories[selectedIndex.row])
        } else {
            delegate?.didApplyFilter(nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func cartButtonTapped() {
        _NavController.presentCartPage()
    }
    
    // MARK: - Binding Data
     override func bindingData() {
        _CartServices.cartData
            .observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
                self.cartHotInfo.cartPriceValue.text = getMoneyFormat(cartDataSource?.customGrandTotal)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
        let cellData = viewModel.listCategories[indexPath.row]
        cell?.setDataSource(data: cellData)
        
        if selectedIndex?.row == indexPath.row && selectedIndex?.section == indexPath.section {
            cell?.setSelected(true)
        } else {
            cell?.setSelected(false)
        }
        
        return cell!
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tempIndex = self.selectedIndex {
            self.selectedIndex = indexPath
            self.collectionview.reloadItems(at: [tempIndex, indexPath])
            return
        }
        
        self.selectedIndex = indexPath
        self.collectionview.reloadItems(at: [indexPath])
    }
}
