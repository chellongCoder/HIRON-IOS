//
//  MainSubscriptionViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import UIKit
import RxSwift

class MainSubscriptionViewController: BaseViewController, UICollectionViewDelegate {
    
    let viewModel           = MainSubscriptionViewModel()
    var imagePicker         = UIImagePickerController()
    var collectionView      : UICollectionView!
    let skipBtn             = UIButton()
    var selectedIndex       : IndexPath? {
        didSet {
            skipBtn.setTitle(selectedIndex == nil ? "Skip":"Confirm", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.controller = self
    }
    
    override func configUI() {
        let backgroundImage = UIImageView(image: UIImage(named: "bg"))
        backgroundImage.contentMode = .scaleAspectFit
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let backBtn = UIButton()
        backBtn.setBackgroundImage(UIImage.init(systemName: "chevron.backward"), for: .normal)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.width.equalTo(20)
        }
        
        let childView = UIView()
        self.view.addSubview(childView)
        childView.layer.cornerRadius = 25
        childView.backgroundColor = UIColor.init(hexString: "1890FF")?.withAlphaComponent(0.2)
        childView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(20)
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        let stackView   = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fillProportionally
        stackView.alignment = .center
        stackView.spacing   = 10.0
        childView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        let subcriptionLabel = UILabel()
        subcriptionLabel.text = "Which plan do you wanna use?"
        subcriptionLabel.font = getFontSize(size: 16, weight: .bold)
        
        let subcriptionLabel2 = UILabel()
        subcriptionLabel2.text = "Save up to 15%"
        subcriptionLabel2.font = getFontSize(size: 14, weight: .regular)
        
        skipBtn.setTitle("Skip", for: .normal)
        skipBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        skipBtn.backgroundColor = kPrimaryColor
        skipBtn.layer.cornerRadius = 8
        
        let viewWidth = UIScreen.main.bounds.size.width/2 - 20
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(SubcriptionCollectionViewCell.self, forCellWithReuseIdentifier: "SubcriptionCollectionViewCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        stackView.addArrangedSubview(subcriptionLabel)
        stackView.addArrangedSubview(subcriptionLabel2)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(skipBtn)
        
        skipBtn.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.getListSubscription()
    }
    
    @objc func continueActionTapped(_ sender: Any) {
        if let selectedIndex = selectedIndex {
            let selectedSubsciptionPlan = self.viewModel.subcriptions.value[selectedIndex.row]
            let viewController = SubscriptionPaymentViewController()
            viewController.viewModel.subscriptionPlan.accept(selectedSubsciptionPlan)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            _NavController.gotoHomepage()
        }
    }
    
    override func bindingData() {
        viewModel.subcriptions
            .bind(to: collectionView.rx.items) { (collectionView: UICollectionView, index: Int, element: SubscriptionData) in
                let indexPath = IndexPath(row: index, section: 0)
                // swiftlint:disable force_cast 
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcriptionCollectionViewCell", for: indexPath) as! SubcriptionCollectionViewCell
                cell.setDataSource(data: element)
                
                if self.selectedIndex?.row == indexPath.row && self.selectedIndex?.section == indexPath.section {
                    cell.setSelected(true)
                } else {
                    cell.setSelected(false)
                }
                
                //                          cell.value?.text = "\(element) @ \(row)"
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UICollectionViewDataSource
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return vm.subcriptions.value.count
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcriptionCollectionViewCell", for: indexPath) as! SubcriptionCollectionViewCell
    //        cell.titleLabel.text = "Monthly subcription"
    //        cell.priceLabel.text = "$ 10.00/month"
    //        cell.footerLabel.text = "Include 14 days free"
    //        let cellData = viewModel.listCategories[indexPath.row]
    //        cell.setDataSource(data: cellData)
    //
    //        if selectedIndex?.row == indexPath.row && selectedIndex?.section == indexPath.section {
    //            cell.setSelected(true)
    //        } else {
    //            cell.setSelected(false)
    //        }
    //
    //        return cell
    //    }
    //
    //    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        if let tempIndex = self.selectedIndex {
            if self.selectedIndex == indexPath {
                self.selectedIndex = nil
            } else {
                self.selectedIndex = indexPath
            }
            self.collectionView.reloadItems(at: [tempIndex, indexPath])
            return
        }
        
        self.selectedIndex = indexPath
        self.collectionView.reloadItems(at: [indexPath])
    }
}
