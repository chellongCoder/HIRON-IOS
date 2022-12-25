//
//  SelectSpecialtyViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

class SelectDepartmentViewController: BaseViewController {

    private let viewModel       = SelectDepartmentViewModel()
    private var collectionView  : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Specialty"
        viewModel.controller = self
        
        self.showBackBtn()
        
        let nextBtn = UIBarButtonItem.init(title: "Next",
                                           style: .plain,
                                           target: self,
                                           action: #selector(nextButtonTapped))
        self.navigationItem.rightBarButtonItem = nextBtn
        
        let viewWidth = UIScreen.main.bounds.size.width/3
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
            make.top.equalToSuperview()
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
    
    // MARK: - Data
    
    override func reloadData() {
        viewModel.getListDepartments()
    }
    
    override func bindingData() {
        
        viewModel.listDepartments
            .bind(to: collectionView!.rx.items(cellIdentifier: "ProductCollectionViewCell") ) { (_: Int, productData: TeamDataSource, cell: SelectDepartmentsCollectionViewCell) in
                if let department = productData.department {
                    cell.setDataSource(department)
                }
                cell.setIsSelected(productData.id == _BookingServices.selectedDepartment.value?.id)
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
