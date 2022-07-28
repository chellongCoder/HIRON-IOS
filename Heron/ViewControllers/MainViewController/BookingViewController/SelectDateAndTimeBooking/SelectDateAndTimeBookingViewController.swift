//
//  SelectDateAndTimeBooking.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import FSCalendar

class SelectDateAndTimeBookingViewController: BaseViewController,
                                FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    let calendar                    = FSCalendar()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Date"

        let backBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let nextBtn = UIBarButtonItem.init(title: "Next",
                                           style: .plain,
                                           target: self,
                                           action: #selector(nextButtonTapped))
        self.navigationItem.rightBarButtonItem = nextBtn
        
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
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(chooseTime.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _NavController.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    // MARK: - UIButton Action
    @objc private func continueButtonTapped() {

    }
    
    @objc private func cancelBtnTapped() {
        collectionView.reloadData()
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
    
    @objc func nextButtonTapped() {
        let chooseDoctorVC = SelectDoctorViewController()
        self.navigationController?.pushViewController(chooseDoctorVC, animated: true)
    }
    
    // MARK: - UICalendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

// MARK: - UICollectionViewDataSource
extension SelectDateAndTimeBookingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDateCollectionViewCell", for: indexPath) as! SelectDateCollectionViewCell
        
        
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
        
        collectionView.reloadData()
        
    }
}
