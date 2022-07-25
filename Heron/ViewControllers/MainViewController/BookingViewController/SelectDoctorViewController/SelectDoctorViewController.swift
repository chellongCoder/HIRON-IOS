//
//  SelectDoctorViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxSwift

class SelectDoctorViewController: UIViewController {
    
    private let viewModel   = SelectDoctorViewModel()
    private let tableView   = UITableView()
    
    private let disposeBag  = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        navigationItem.title = "Select Doctors"
        
        viewModel.controller = self

        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(SelectDoctorTableViewCell.self, forCellReuseIdentifier: "SelectDoctorTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.getListDoctor()
    }
    
    // MARK: - Buttons
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data
    private func bindingData() {
        viewModel.listDoctor
            .bind(to: tableView.rx.items) { (_: UITableView, _: Int, element: DoctorDataSource) in
                let cell = SelectDoctorTableViewCell(style: .default, reuseIdentifier:"SelectDoctorTableViewCell")
                cell.setDataSource(element)
                cell.setIsSelected(element.id == _BookingServices.selectedDoctor.value?.id)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              self?.tableView.deselectRow(at: indexPath, animated: true)
          }).disposed(by: disposeBag)

    }
}
