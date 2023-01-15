//
//  SelectDateAndTimeBooking.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import FSCalendar
import RxSwift

class SelectDateAndTimeBookingViewController: BaseViewController,
                                              FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    private let viewModel           = SelectDateAndTimeBookingViewModel()
    
    private let stepView            = BookingStepView(step: 2)
    let calendar                    = FSCalendar()
    var collectionView              : UICollectionView?
    let emptyView                   = EmptyView()
    let confirmBtn                  = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Visiting Date"
        self.viewModel.controller = self

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
        
        let calendarView = UIView()
        calendarView.layer.borderWidth = 0.7
        calendarView.layer.borderColor = kPrimaryColor.cgColor
        calendarView.layer.cornerRadius = 10
        calendarView.backgroundColor = .white
        calendarView.layer.shadowColor = UIColor.black.cgColor // Màu đổ bóng
        calendarView.layer.shadowOffset = CGSize(width: 1, height: 1) // Hướng đổ bóng + right/bottom, - left/top
        calendarView.layer.shadowRadius = 6 // Độ rộng đổ bóng
        calendarView.layer.shadowOpacity = 0.3 // Độ đậm nhạt
        self.view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(calendarView.snp.width).multipliedBy(0.85)
        }
        
        calendar.dataSource = self
        calendar.delegate = self
        calendarView.addSubview(calendar)
        calendar.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        let chooseTime = UILabel()
        chooseTime.text = NSLocalizedString("Visiting Time", comment: "")
        chooseTime.textColor = kDefaultTextColor
        chooseTime.textAlignment = .center
        chooseTime.font = getCustomFont(size: 13.5, name: .bold)
        self.view.addSubview(chooseTime)
        chooseTime.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
        }
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        confirmBtn.setTitle("Continue", for: .normal)
        confirmBtn.titleLabel?.font = getCustomFont(size: 14, name: .bold)
        confirmBtn.isUserInteractionEnabled = false
        confirmBtn.layer.cornerRadius = 20
        confirmBtn.backgroundColor = kDisableColor
        confirmBtn.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        bottomView.addSubview(self.confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-56)
            make.height.equalTo(40)
        }

        let layout = SelectDateCalendarFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.scrollDirection = .vertical
        
        self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.collectionView?.isScrollEnabled = true
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(SelectDateCollectionViewCell.self, forCellWithReuseIdentifier: "SelectDateCollectionViewCell")
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        
        self.view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints({ (make) in
            make.top.equalTo(chooseTime.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
        })
        
        emptyView.titleLabel.text = "Sorry, it seems like there are no doctors available for this date"
        emptyView.messageLabel.text = "Please select a different date.\n(Dates with a dot next by on calendar)"
        emptyView.actionButon.isHidden = true
        emptyView.isHidden = true
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.size.equalTo(collectionView!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewModel.getListTimeable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    // MARK: - UIButton Action
    @objc private func continueButtonTapped() {
        let confirmBooking = ConfirmBookingViewController()
        self.navigationController?.pushViewController(confirmBooking, animated: true)
    }
    
    @objc private func cancelBtnTapped() {
        collectionView!.reloadData()
    }
    
//    @objc func prevButtonTapped() {
//        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)!
//        calendar.setCurrentPage(previousMonth, animated: true)
//    }
//
//    @objc func nextButtonTapped() {
//        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)!
//        calendar.setCurrentPage(nextMonth, animated: true)
//    }
    
    override func backButtonTapped() {
        _BookingServices.selectedTimeable.accept(nil)
        self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Mapping Data
    override func bindingData() {
        viewModel.listTimeables
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.collectionView?.reloadData()
                self.calendar.reloadData()
            }
            .disposed(by: disposeBag)
        
        _BookingServices.selectedTimeable
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                if _BookingServices.selectedTimeable.value != nil {
                    self.confirmBtn.isUserInteractionEnabled = true
                    self.confirmBtn.backgroundColor = kPrimaryColor
                } else {
                    self.confirmBtn.isUserInteractionEnabled = false
                    self.confirmBtn.backgroundColor = .white
                    self.confirmBtn.setTitleColor(kPrimaryColor, for: .normal)
                    self.confirmBtn.layer.borderColor = kPrimaryColor.cgColor
                    self.confirmBtn.layer.borderWidth = 0.7
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UICalendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.selectedDate = date
        _BookingServices.selectedTimeable.accept(nil)
        self.collectionView?.reloadData()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let listEvents = viewModel.getListTimeableByDate(date)
        
        if listEvents.isEmpty {
            return 0
        } else if listEvents.count == 1 {
            return 1
        } else if listEvents.count > 1 && listEvents.count < 5 {
            return 2
        } else {
            return 3
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SelectDateAndTimeBookingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.getListTimeableByDate().isEmpty {
            self.collectionView?.isHidden = true
            self.emptyView.isHidden = false
        } else {
            self.collectionView?.isHidden = false
            self.emptyView.isHidden = true
        }
        
        return viewModel.getListTimeableByDate().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDateCollectionViewCell", for: indexPath) as! SelectDateCollectionViewCell
        
        let cellData = viewModel.getListTimeableByDate()[indexPath.row]
        if cellData == _BookingServices.selectedTimeable.value {
            cell.layoutView.layer.borderWidth = 0
            cell.layoutView.backgroundColor = kPrimaryColor
            cell.selectOption.textColor = .white
        } else {
            cell.layoutView.layer.borderWidth = 1
            cell.layoutView.backgroundColor = .white
            cell.selectOption.textColor = kDefaultTextColor
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US")
        let startTimeStr = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(cellData.startTime / 1000)))
        let endTimeStr = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(cellData.endTime / 1000)))
        cell.selectOption.text = startTimeStr + "-" + endTimeStr
        cell.layoutSubviews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return resizeView(list: [], indexPath: indexPath, height: 46)
    }
    
    func resizeView(list: [String], indexPath: IndexPath, height: CGFloat) -> CGSize {
        let extraSpace: CGFloat = 32 + 4
        let width = 80 + extraSpace
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate, CustomWidthLayoutDelegate
extension SelectDateAndTimeBookingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = viewModel.getListTimeableByDate()[indexPath.row]
        _BookingServices.selectedTimeable.accept(cellData)
        collectionView.reloadData()
    }
}
