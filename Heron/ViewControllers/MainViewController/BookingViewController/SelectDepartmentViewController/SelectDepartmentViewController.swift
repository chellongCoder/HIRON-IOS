//
//  SelectSpecialtyViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

class SelectDepartmentViewController: BaseViewController {

    private let viewModel   = SelectDepartmentViewModel()
    private let tableView   = UITableView()
    
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
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(SelectDepartmentsTableViewCell.self, forCellReuseIdentifier: "SelectDepartmentsTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.width.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.getListDepartments()
    }
    
    // MARK: - Buttons
    @objc private func nextButtonTapped() {
        let selectDoctorVC = SelectDateAndTimeBookingViewController()
        self.navigationController?.pushViewController(selectDoctorVC, animated: true)
    }
    
    // MARK: - Data
    override func bindingData() {
        viewModel.listDepartments
            .bind(to: tableView.rx.items) { (_: UITableView, _: Int, element: DepartmentDataSource) in
                let cell = SelectDepartmentsTableViewCell(style: .default, reuseIdentifier:"SelectDoctorTableViewCell")
                cell.setDataSource(element)
                cell.setIsSelected(element.id == _BookingServices.selectedDepartment.value?.id)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              
              let elementData = self?.viewModel.listDepartments.value[indexPath.row]
              _BookingServices.selectedDepartment.accept(elementData)
              
              self?.tableView.reloadData()
              
          }).disposed(by: disposeBag)

    }
}
