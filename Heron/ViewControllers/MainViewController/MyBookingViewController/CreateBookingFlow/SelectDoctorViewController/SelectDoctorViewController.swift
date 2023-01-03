//
//  SelectDoctorViewController.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import RxSwift

class SelectDoctorViewController: BaseViewController, SelectDoctorCellDelegate {
    
    private let viewModel   = SelectDoctorViewModel()
    private let tableView   = UITableView()
    private let emptyView   = EmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose Doctor"
        viewModel.controller = self
        
//        self.showBackBtn()
        
        let moreBtn = UIBarButtonItem.init(image: UIImage.init(named: "moreI_bar_icon"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(moreButtonTapped))
        let filterBtn = UIBarButtonItem.init(image: UIImage.init(named: "filter_funnel_choose"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(moreButtonTapped))
        let sliderBtn = UIBarButtonItem.init(image: UIImage.init(named: "sliders_choose"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(moreButtonTapped))
        self.navigationItem.rightBarButtonItems = [moreBtn, filterBtn, sliderBtn]
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(named: "back_icon_nav"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        let searchBtn = UIBarButtonItem.init(image: UIImage.init(named: "search_choose"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(moreButtonTapped))
        self.navigationItem.leftBarButtonItems = [backBtn, searchBtn]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = kBackgroundColor
        tableView.register(SelectDoctorTableViewCell.self, forCellReuseIdentifier: "SelectDoctorTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        emptyView.titleLabel.text = "Sorry, it seems like there are no doctor available at this current time"
        emptyView.messageLabel.text = ""
        emptyView.actionButon.isHidden = true
        emptyView.isHidden = true
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.size.equalTo(tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.getListDoctor()
    }
    
    override func backButtonTapped() {
        _BookingServices.selectedDoctor.accept(nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data
    override func reloadData() {
        viewModel.getListDoctor()
    }
    
    override func bindingData() {
        viewModel.listDoctor
            .observe(on: MainScheduler.instance)
            .subscribe { listDoctor in
                
                if listDoctor.element?.isEmpty ?? false {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.listDoctor
            .bind(to: tableView.rx.items) { (_: UITableView, index: Int, element: DoctorDataSource) in
                let cell = SelectDoctorTableViewCell(style: .default, reuseIdentifier:"SelectDoctorTableViewCell")
                cell.setDataSource(element)
                cell.setIsSelected(element.id == _BookingServices.selectedDoctor.value?.id)
                cell.delegate = self
                cell.setIndexPath(index)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              
              if let cellData = self?.viewModel.listDoctor.value[indexPath.row] {
                  
                  _BookingServices.selectedDoctor.accept(cellData)
                  
                  let doctorDetailsVC = DoctorDetailsViewController()
                  doctorDetailsVC.setDoctorDataSource(cellData)
                  self?.navigationController?.pushViewController(doctorDetailsVC, animated: true)
              }
          }).disposed(by: disposeBag)

    }
    
    // MARK: - UIButton Action
    
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
    
    // MARK: - SelectDoctorCellDelegate
    func bookNow(_ indexPath: Int) {
        let cellData = self.viewModel.listDoctor.value[indexPath]
        _BookingServices.selectedDoctor.accept(cellData)
        let selectDateVC = SelectDateAndTimeBookingViewController()
        self.navigationController?.pushViewController(selectDateVC, animated: true)
    }
}
