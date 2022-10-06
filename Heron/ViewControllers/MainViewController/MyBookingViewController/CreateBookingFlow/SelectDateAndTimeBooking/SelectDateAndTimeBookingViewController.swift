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
    
    let calendar                    = FSCalendar()
    var collectionView              : UICollectionView?
    let emptyView                   = EmptyView()
    let confirmBtn                  = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Date"
        self.viewModel.controller = self

        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
                
        calendar.dataSource = self
        calendar.delegate = self
        self.view.addSubview(calendar)
        calendar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(calendar.snp.width).multipliedBy(0.85)
        }
        
        let chooseTime = UILabel()
        chooseTime.text = NSLocalizedString("Select time", comment: "")
        chooseTime.textColor = .lightGray
        chooseTime.font = getFontSize(size: 16, weight: .medium)
        self.view.addSubview(chooseTime)
        chooseTime.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        confirmBtn.setTitle("Continue", for: .normal)
        confirmBtn.isUserInteractionEnabled = false
        confirmBtn.layer.cornerRadius = 8
        confirmBtn.backgroundColor = kDisableColor
        confirmBtn.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        bottomView.addSubview(self.confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(50)
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
        emptyView.messageLabel.text = "Please select different date with availability (dates with a dot next by on calendar)"
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
        self.navigationController?.popViewController(animated: true)
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
                    self.confirmBtn.backgroundColor = kDisableColor
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
