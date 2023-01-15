//
//  SelectSpecialtyViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

class SelectDepartmentViewController: BaseViewController {

    private let viewModel       = SelectDepartmentViewModel()
    private let stepView        = BookingStepView(step: 0)
    private var collectionView  : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose a service"
        viewModel.controller = self
        
        self.showBackBtn()
        let moreBtn = UIBarButtonItem.init(image: UIImage.init(named: "moreI_bar_icon"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(moreButtonTapped))
        self.navigationItem.rightBarButtonItem = moreBtn
        
        self.view.addSubview(stepView)
        stepView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        let line = UIView()
        line.backgroundColor = kDisableColor
        self.view.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom)
            make.height.equalTo(0.5)
            make.width.equalToSuperview()
        }
        
        let textLabel = UILabel()
        textLabel.text = "Please select the service you are care."
        textLabel.font = getCustomFont(size: 13.5, name: .semiBold)
        textLabel.textColor = kDefaultTextColor
        self.view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        let viewWidth = UIScreen.main.bounds.size.width/2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        var fixedHeight = viewWidth // 1 row
        if viewModel.listDepartments.value.count >= 6 {
            // 2 rows
            fixedHeight = viewWidth*2
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(SelectDepartmentsCollectionViewCell.self, forCellWithReuseIdentifier: "SelectDepartmentsCollectionViewCell")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.isScrollEnabled = false
        collectionView?.backgroundColor = .white
        self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(fixedHeight)
            make.bottom.lessThanOrEqualToSuperview().offset(-50)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.getListDepartments()
    }
    
    // MARK: - Buttons
    @objc private func nextButtonTapped() {
        let selectDoctorVC = SelectDoctorViewController()
        self.navigationController?.pushViewController(selectDoctorVC, animated: true)
    }
    
    @objc private func moreButtonTapped() {
        let alertVC = UIAlertController.init(title: NSLocalizedString("Ops!", comment: ""),
                                             message: "This feature is not available at the moment.",
                                             preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                             style: .default,
                                             handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
    
    // MARK: - Data
    
    override func reloadData() {
        viewModel.getListDepartments()
    }
    
    override func bindingData() {
        
        viewModel.listDepartments
            .bind(to: collectionView!.rx.items(cellIdentifier: "SelectDepartmentsCollectionViewCell") ) { ( index: Int, productData: TeamDataSource, cell: SelectDepartmentsCollectionViewCell) in
                cell.cellContentView.backgroundColor = self.viewModel.getBackgroundColor(index)
                if let department = productData.department {
                    cell.setDataSource(department)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView?.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              
              let elementData = self?.viewModel.listDepartments.value[indexPath.row]
              _BookingServices.selectedDepartment.accept(elementData)
              
              self?.collectionView?.reloadData()
              self?.nextButtonTapped()
              
          }).disposed(by: disposeBag)

    }
}
