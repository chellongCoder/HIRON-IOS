//
//  MyApoitmentViewController.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit
import RxSwift

class MyApoitmentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let stackView       = UIStackView()
    let tableView               = UITableView(frame: .zero, style: .plain)
    let viewModel               = MyApoitmentViewModel()
    private let pendingBtn      = UIButton()
    private let confirmedBtn    = UIButton()
    private let completeBtn     = UIButton()
    private var separatorView   = UIView()
    
    private var selectedSegmentBtn      : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Appointments"
        self.viewModel.controller = self
        
        self.showBackBtn()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 1
        stackView.backgroundColor = .white
        self.loadHeaderView(stackView: stackView)
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(46)
        }
        
        separatorView.backgroundColor = kPrimaryColor
        self.view.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalTo(selectedSegmentBtn!)
            make.height.equalTo(2)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(MyAppoitmentTableViewCell.self, forCellReuseIdentifier: "MyAppoitmentTableViewCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.filter.accept("confirmed")
    }
    
    private func loadHeaderView(stackView: UIStackView) {
        pendingBtn.isSelected = true
        self.selectedSegmentBtn = pendingBtn
        pendingBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        pendingBtn.setTitle("Pending", for: .normal)
        pendingBtn.setTitleColor(kDefaultTextColor, for: .normal)
        pendingBtn.setTitleColor(kPrimaryColor, for: .selected)
        pendingBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        pendingBtn.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        stackView.addArrangedSubview(pendingBtn)
        
        confirmedBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        confirmedBtn.setTitle("Confirmed", for: .normal)
        confirmedBtn.setTitleColor(kDefaultTextColor, for: .normal)
        confirmedBtn.setTitleColor(kPrimaryColor, for: .selected)
        confirmedBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        confirmedBtn.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        stackView.addArrangedSubview(confirmedBtn)
        
        completeBtn.addTarget(self, action: #selector(segmentBtnTapped(sender:)), for: .touchUpInside)
        completeBtn.setTitle("Complete", for: .normal)
        completeBtn.setTitleColor(kDefaultTextColor, for: .normal)
        completeBtn.setTitleColor(kPrimaryColor, for: .selected)
        completeBtn.titleLabel?.font = getFontSize(size: 12, weight: .semibold)
        completeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(46)
        }
        stackView.addArrangedSubview(completeBtn)
    }
    
    @objc private func segmentBtnTapped(sender: UIButton) {
        
        if selectedSegmentBtn == sender {
            return
        }
        
        selectedSegmentBtn?.isSelected = false
        sender.isSelected = true
        selectedSegmentBtn = sender
        
        separatorView.snp.remakeConstraints { (remake) in
            remake.bottom.centerX.width.equalTo(selectedSegmentBtn!)
            remake.height.equalTo(2)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        switch sender {
        case self.pendingBtn:
            self.viewModel.filter.accept("pending")
            //tableViewIsScrolling = true
        case self.confirmedBtn:
            self.viewModel.filter.accept("confirmed")
            //tableViewIsScrolling = true
        case self.completeBtn:
            self.viewModel.filter.accept("completed")
            //tableViewIsScrolling = true
        default:
            break
        }
    }
    
    //MARK: - Binding Data
    override func bindingData() {
        viewModel.listAppoitments
            .observe(on: MainScheduler.instance)
            .subscribe { data in
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listAppoitments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppoitmentTableViewCell") as! MyAppoitmentTableViewCell
        return cell
    }
}
