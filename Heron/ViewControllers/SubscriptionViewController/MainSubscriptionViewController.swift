//
//  MainSubscriptionViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import UIKit
import RxSwift
import RxRelay

class MainSubscriptionViewController: BaseViewController, UICollectionViewDelegate, SubcriptionCellDelegate {
   
    private let listItems       = UIScrollView()
    private let pageControl     = UIPageControl()
    
    let viewModel               = MainSubscriptionViewModel()
    var imagePicker             = UIImagePickerController()
    let skipBtn                 = UIButton()
    let confirmBtn              = UIButton()
    var selectedPlan            = BehaviorRelay<SubscriptionData?>(value: nil)
    var currentlySub        : UserRegisteredSubscription?
    
    override func viewDidLoad() {
        self.viewModel.controller = self
        self.view.backgroundColor = kBackgroundColor
        
        let logoImage = UIImageView()
        logoImage.image = UIImage.init(named: "logo")
        self.view.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(24)
            make.width.equalTo(107)
        }
        
        skipBtn.setTitle("Skip", for: .normal)
        skipBtn.titleLabel?.font = getCustomFont(size: 13, name: .regular)
        skipBtn.setTitleColor(kDefaultTextColor, for: .normal)
        skipBtn.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        self.view.addSubview(skipBtn)
        skipBtn.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.top)
            make.right.equalToSuperview().offset(-16)
        }
            
        listItems.isPagingEnabled = true
        listItems.delegate = self
        listItems.showsHorizontalScrollIndicator = false
        self.view.addSubview(listItems)
        listItems.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(40)
            make.right.left.equalToSuperview()
            make.height.equalTo(250)
        }
        self.reloadItemScrollView()
        
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = kLightGrayColor
        pageControl.currentPageIndicatorTintColor = kLoginTextColor
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(listItems.snp.bottom).offset(10)
        }
        
        confirmBtn.setTitle("Start your 14 days free trial", for: .normal)
        confirmBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.layer.backgroundColor = kPrimaryColor.cgColor
        confirmBtn.layer.cornerRadius = 20
        confirmBtn.layer.masksToBounds = true
        confirmBtn.addTarget(self, action: #selector(continueActionTapped), for: .touchUpInside)
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        let contentScrollView = UIScrollView()
        contentScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(pageControl.snp.bottom).offset(10)
            $0.bottom.equalTo(confirmBtn.snp.top).offset(-20)
        }
        
        let childViewOfScrollView = UIView()
        contentScrollView.addSubview(childViewOfScrollView)
        childViewOfScrollView.snp.makeConstraints { make in
            make.top.left.bottom.right.width.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Features"
        titleLabel.font = getCustomFont(size: 11, name: .extraBold)
        titleLabel.textColor = kDefaultTextColor
        childViewOfScrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(70)
        }
        
        var lastView : UIView = titleLabel
        
        #warning("HARD_CODE")
        for index in 1...7 {
            let iconImage = UIImageView()
            iconImage.image = UIImage.init(named: "check_mark_icon")
            childViewOfScrollView.addSubview(iconImage)
            iconImage.snp.makeConstraints { make in
                make.top.equalTo(lastView.snp.bottom).offset(15)
                make.left.equalToSuperview().offset(35)
                make.height.width.equalTo(16)
            }
            
            let cellLabel = UILabel()
            cellLabel.text = "Lorem Ipsum is simply the printing and typesetting"
            cellLabel.textColor = kDefaultTextColor
            cellLabel.textAlignment = .left
            cellLabel.font = getCustomFont(size: 13, name: .light)
            cellLabel.numberOfLines = 0
            contentScrollView.addSubview(cellLabel)
            cellLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(iconImage.snp.top).offset(-2)
                make.left.equalTo(iconImage.snp.right).offset(20)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            }
            
            lastView = cellLabel
        }
        
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.getListSubscription()
    }
    
    private func reloadItemScrollView() {
        // remove all subviews
        for subView in listItems.subviews {
            subView.removeFromSuperview()
        }
        
        let listItemData = self.viewModel.subcriptions.value

        let size = CGSize(width: UIScreen.main.bounds.size.width/2, height: 250)
        var index = 0
        
        for subscriptionData in listItemData {
            
            let frame = CGRect.init(x: CGFloat(index)*(size.width), y: 0, width: size.width, height: size.height)
            let cell = SubcriptionCell.init(frame: frame)
            cell.delegate = self
            cell.setDataSource(data: subscriptionData, currentSelectedPlan: selectedPlan.value)
            listItems.addSubview(cell)
            
            index += 1
        }
//        self.pageControl.numberOfPages = listItems.count
        listItems.contentSize = CGSize.init(width: CGFloat(listItemData.count)*(size.width), height: size.height)
    }
    
    @objc func continueActionTapped() {
        
        if let selectedPlan = selectedPlan.value {
            
            // switch plan
            if let currentPlan = currentlySub {
                viewModel.switchPlanTo(fromPlan: currentPlan, toPlan: selectedPlan)
                return
            }
            
            let viewController = SubscriptionPaymentViewController()
            viewController.viewModel.subscriptionPlan.accept(selectedPlan)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc private func skipButtonTapped() {
        _NavController.gotoHomepage()
    }
    
    // MARK: - Data
    override func bindingData() {
        viewModel.subcriptions
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.reloadItemScrollView()
                self.pageControl.numberOfPages = self.viewModel.subcriptions.value.count
            }
            .disposed(by: disposeBag)
        self.selectedPlan
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                if self.selectedPlan.value == nil {
                    self.confirmBtn.setTitleColor(.white, for: .normal)
                    self.confirmBtn.layer.backgroundColor = kDisableColor.cgColor
                    self.confirmBtn.isUserInteractionEnabled = false
                } else {
                    self.confirmBtn.setTitleColor(.white, for: .normal)
                    self.confirmBtn.layer.backgroundColor = kPrimaryColor.cgColor
                    self.confirmBtn.isUserInteractionEnabled = true
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - SubcriptionCellDelegate
    func didSelectPlan(_ plan: SubscriptionData) {
        if plan == self.selectedPlan.value {
            self.selectedPlan.accept(nil)
        } else {
            self.selectedPlan.accept(plan)
        }
        self.reloadItemScrollView()
        
        let index = self.viewModel.subcriptions.value.firstIndex(of: plan)
        self.pageControl.currentPage = index ?? 0
    }
}
